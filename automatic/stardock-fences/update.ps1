Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$history_page = 'https://www.stardock.com/products/fences/history'

# Supported major versions (streams)
$majorVersions = @(3, 4, 5, 6)

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
        default { return $null }
    }
}

function CreateStream {
    param([int]$major, [string]$content)

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

    $releases = Invoke-WebRequest -Uri $history_page -UseBasicParsing
    $content = $releases.Content

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

Update-Package -ChecksumFor none
