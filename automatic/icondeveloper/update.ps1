Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$history_page = 'https://www.stardock.com/products/icondeveloper/history'

function global:au_GetLatest {
  $releases = Invoke-WebRequest -Uri $history_page -UseBasicParsing

  $Url = 'https://cdn.stardock.us/downloads/public/software/icondeveloper/IconDeveloper_setup_sd.exe'

  # Match versions like "IconDeveloper 2.13"
  $re = "IconDeveloper (?<version>\d+\.\d+(?:\.\d+)*)"
  $null = $releases.Content -match $re
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
