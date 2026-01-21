Import-Module Chocolatey-AU

$releases = 'https://support.creative.com/Downloads/searchdownloads.aspx?filename=CreativeApp&ShowAll=1'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  # Extract version from filename pattern like CreativeAppSetup_1.23.04.00.exe
  $re = 'CreativeAppSetup_(\d+)\.(\d+)\.(\d+)\.(\d+)\.exe'
  if ($download_page.Content -match $re) {
    $versionParts = @($Matches[1], $Matches[2], $Matches[3], $Matches[4])
    # Version for nuspec: 1.23.4.0 (remove leading zeros from minor parts)
    $version = "$($versionParts[0]).$([int]$versionParts[1]).$([int]$versionParts[2]).$([int]$versionParts[3])"
    # Version for URL: 1.23.04.00 (keep the original format with leading zeros)
    $urlVersion = "$($versionParts[0]).$($versionParts[1]).$($versionParts[2]).$($versionParts[3])"
  } else {
    throw "Could not find version in download page"
  }

  $Url32 = "https://files.creative.com/creative/bin/apps/swureleases/win/creativeapp/release/CreativeAppSetup_$urlVersion.exe"
  $ChecksumType = 'sha256'

  @{
    Url32          = $Url32
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
