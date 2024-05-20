Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.royalapps.com/server/main/download'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '.msi'
  $Url32 = $download_page.Links | Where-Object { $_.href -match $re } | Where-Object { $_.title -like '*Server' } | Select-Object -First 1 -ExpandProperty href
  $version = $Url32 -split '_|.msi' | Select-Object -First 1 -Skip 1
  $version = $version -replace '\.0$', '' # drops last octet if version ends in `.0`
  $ChecksumType = 'sha256'

  $support_url = 'https://support.royalapps.com/support/home'
  $support_page = Invoke-WebRequest -Uri $support_url -UseBasicParsing

  $static = 'https://support.royalapps.com'
  $re = '*royal-server*release-notes'
  $ReleaseNotes = $static + ($support_page.links | Where-Object { $_.href -like $re } | Select-Object -First 1 -ExpandProperty href)

  @{
    Url32             = $Url32
    Version           = $version
    ChecksumType32    = $ChecksumType
    ReleaseNotes      = $ReleaseNotes
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

function global:au_AfterUpdate {
  Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor none
