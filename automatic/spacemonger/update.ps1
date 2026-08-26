Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$history_page = 'https://forums.stardock.com/499121/spacemonger-history'

function global:au_GetLatest {
  $Url = 'https://cdn.stardock.us/downloads/public/software/spacemonger/SpaceMonger_sd_setup.exe'

  # Match versions like "Space Monger 3.0" (note: two words on forums page)
  $re = "Space\s*Monger\s+(?<version>\d+\.\d+(?:\.\d+)*)"
  $content = Get-RetryWebContent $history_page -MustMatch $re
  $null = $content -match $re
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
