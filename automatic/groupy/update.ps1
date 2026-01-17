Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$history_page = 'https://www.stardock.com/products/groupy/history'

function global:au_GetLatest {
    $response = Invoke-WebRequest -Uri $history_page -UseBasicParsing
    $content  = $response.Content

    $headingRe = 'Groupy\s+(?<version>2\.\d+(?:\.\d+)*)\s+Changelog'
    $headingMatches   = [regex]::Matches($content, $headingRe)

    # Collect raw version strings (e.g. "2.30", "2.20")
    $versionStrings = $headingMatches |
        ForEach-Object { $_.Groups['version'].Value.Trim() } |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        Sort-Object -Unique

    # Turn them into comparable objects and pick the highest
    $parsed = foreach ($v in $versionStrings) {
        $parts = $v -split '\.'
        if ($parts.Count -lt 2) { continue }

        [pscustomobject]@{
            Raw   = $v
            Major = [int]$parts[0]
            Minor = [int]$parts[1]
            Patch = if ($parts.Count -ge 3) { [int]$parts[2] } else { 0 }
            Build = if ($parts.Count -ge 4) { [int]$parts[3] } else { 0 }
        }
    }

    if (-not $parsed -or $parsed.Count -eq 0) {
        throw "Failed to parse any numeric versions from headings on $history_page"
    }

    # Highest version wins
    $latestObj      = $parsed | Sort-Object Major,Minor,Patch,Build -Descending | Select-Object -First 1
    $headingVersion = $latestObj.Raw

    # Normalize to 3 or 4 parts
    $parts = $headingVersion -split '\.'
    while ($parts.Count -lt 3) { $parts += '0' }
    if ($parts.Count -gt 4) { $parts = $parts[0..3] }
    $version = ($parts -join '.')

    $Url          = 'https://cdn.stardock.us/downloads/public/software/groupy/Groupy2_setup.exe'
    $ChecksumType = 'sha256'

    @{
        Url32          = $Url
        Version        = $version
        ChecksumType32 = $ChecksumType
    }
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
