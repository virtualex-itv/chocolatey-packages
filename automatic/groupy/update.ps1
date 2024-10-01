Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$history_page = 'https://www.stardock.com/products/groupy/history'

function global:au_GetLatest {
  $releases = Invoke-WebRequest -Uri $history_page -UseBasicParsing

  $Url = 'https://cdn.stardock.us/downloads/public/software/groupy/Groupy2_setup.exe'

  $re  = "Groupy\s(?<version>\d+(\.\d+)+)\s*(?<beta>Beta)?"
  $version = $releases.Content -match $re | ForEach-Object {
    $versionNumber = $Matches.version

    if ($versionNumber -notlike "*.*.*") {
        $versionNumber += ".0"
    }

    if ($Matches.beta) {
        $versionNumber + "-beta"
    } else {
        $versionNumber
    }
  }

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
