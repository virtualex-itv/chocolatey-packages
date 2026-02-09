Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$history_page = 'https://www.stardock.com/products/objectdock/history'

function global:au_GetLatest {
  $releases = Invoke-WebRequest -Uri $history_page -UseBasicParsing
  $content = $releases.Content

  # Get download URL from trial page
  $downloadPage = Invoke-WebRequest -Uri 'https://www.stardock.com/products/objectdock/download-trial' -UseBasicParsing
  $null = $downloadPage.Content -match '(https?://[^\s"<>]+ObjectDock[^\s"<>]*\.exe)'
  $Url = $Matches[0]

  # Parse version from history page (e.g., "UI: 3.01")
  $pattern = 'UI:\s*(?<version>\d+\.\d+(?:\.\d+)*)'
  $null = $content -match $pattern
  $version = $Matches.version
  $ChecksumType = 'sha256'

  @{
    Url32             = $Url
    Version           = $version
    ChecksumType32    = $ChecksumType
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
