Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$history_page = 'https://www.stardock.com/products/fences/history'

# Supported major versions (streams)
$majorVersions = @(3, 4, 5, 6, 7)

# Majors the history page does not list yet: version comes from the installer, cached by ETag + Content-Length in .\info
$installerVersionMajors = @(7)

function Get-InstallerVersion {
    param([string]$stream, [string]$url)

    $request = [System.Net.WebRequest]::CreateDefault($url)
    $request.Method = 'HEAD'
    $response = $request.GetResponse()
    $etag = $response.Headers.Get('ETag'); $length = $response.ContentLength.ToString()
    $response.Dispose()

    # info: one line per stream, stream|ETag|Content-Length|Version
    $infoFile = Join-Path $PSScriptRoot 'info'
    $lines = @(if (Test-Path $infoFile) { Get-Content $infoFile -Encoding UTF8 | Where-Object { $_ } })
    $cached = $lines | Where-Object { $_ -like "$stream|*" } | Select-Object -First 1
    if ($cached) {
        $p = $cached -split '\|'
        if ($p[1] -eq $etag -and $p[2] -eq $length) { return $p[3] }
    }

    $dest = Join-Path $env:TEMP (Split-Path -Leaf $url)
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    $version = (Get-Command $dest).FileVersionInfo.ProductVersion
    Remove-Item $dest -Force -ErrorAction SilentlyContinue
    if (-not $version) { throw "Could not read a version from $url" }
    $version = $version.Trim()

    $lines = @($lines | Where-Object { $_ -notlike "$stream|*" }) + "$stream|$etag|$length|$version" | Sort-Object
    $lines | Set-Content $infoFile -Encoding UTF8
    return $version
}

function ConvertTo-FileVersion {
    param([string]$version, [int]$major)

    # If already in X.Y.Z.B format (4 parts), return as-is
    $parts = $version.Split('.')
    if ($parts.Count -ge 4) {
        return $version
    }

    # Handle display format like "3.18" -> "3.1.8" or "6.20" -> "6.2.0"
    # Pattern: X.YZ where YZ are two digits representing Y and Z
    if ($parts.Count -eq 2 -and $parts[1].Length -eq 2) {
        $y = $parts[1][0].ToString()
        $z = $parts[1][1].ToString()
        return "$major.$y.$z"
    }

    # Handle format like "6.0" -> "6.0.0"
    if ($parts.Count -eq 2 -and $parts[1].Length -eq 1) {
        return "$major.$($parts[1]).0"
    }

    # Handle format like "5.0.0" -> keep as is
    if ($parts.Count -eq 3) {
        return $version
    }

    return $version
}

function Get-DownloadUrl {
    param([int]$major)

    # Each major version has a different URL pattern
    switch ($major) {
        3 { return 'https://stardock.cachefly.net/software/Fences/Fences3/Fences3_setup_sd.exe' }
        4 { return 'https://stardock.cachefly.net/software/Fences4_setup.exe' }
        5 { return 'https://cdn.stardock.us/downloads/public/software/fences/v5/Fences5_setup.exe?a=sd' }
        6 { return 'https://stardock.cachefly.net/software/Fences6_setup.exe' }
        7 { return 'https://stardock.cachefly.net/software/Fences/Fences7/Fences7_setup.exe' }
        default { return $null }
    }
}

function CreateStream {
    param([int]$major, [string]$content)

    if ($major -in $installerVersionMajors) {
        $Url = Get-DownloadUrl -major $major
        return @{ Url32 = $Url; Version = (Get-InstallerVersion -stream "$major" -url $Url); ChecksumType32 = 'sha256' }
    }

    # Match version patterns for this major version
    # Handles: "Fences v3.18", "Fences 4 v4.23", "Fences 5.89", "Fences 6.2.0.1"
    $pattern = "Fences\s*$major?\s*v?($major\.\d+(?:\.\d+)*)"
    $versionMatches = [regex]::Matches($content, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    $version = $null
    foreach ($m in $versionMatches) {
        $rawVersion = $m.Groups[1].Value
        # Skip beta versions
        if ($content.Substring([Math]::Max(0, $m.Index - 50), [Math]::Min(100, $content.Length - $m.Index + 50)) -match 'beta') {
            continue
        }
        $version = ConvertTo-FileVersion -version $rawVersion -major $major
        break
    }

    if (-not $version) {
        return $null
    }

    $Url = Get-DownloadUrl -major $major
    if (-not $Url) {
        return $null
    }

    $ChecksumType = 'sha256'

    return @{
        Url32          = $Url
        Version        = $version
        ChecksumType32 = $ChecksumType
    }
}

function global:au_GetLatest {
    $streams = @{}

    # Guard on a real changelog entry, not just 'Fences <digit>': that matches the page's own
    # navigation ("Fences 6 Page Navigation Fences 6 Download"), so a stub page satisfied the
    # retry, passed through, and then yielded no versions at all.
    $content = Get-RetryWebContent $history_page -MustMatch 'Changelog\s*\(Released'

    foreach ($major in $majorVersions) {
        $stream = CreateStream -major $major -content $content
        if ($stream) {
            $streams[$major.ToString()] = $stream
        }
    }

    if ($streams.Count -eq 0) {
        throw "No Fences versions found on history page"
    }

    return @{ Streams = $streams }
}

function global:au_BeforeUpdate {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32 -Algorithm $Latest.ChecksumType32
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.Url32)'"
            "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
}

Update-Package -ChecksumFor none -NoReadme
