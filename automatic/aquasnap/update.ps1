Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.nurgo-software.com/pricing/aquasnap'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '.msi'
  $url = $download_page.links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href
  $Url32 = 'https://www.nurgo-software.com' + $url
  $ChecksumType = 'sha256'

  $versUrl = 'https://www.nurgo-software.com/company/news/13-aquasnap'
  $versPage = Invoke-WebRequest -Uri $versUrl -UseBasicParsing

  $re = "AquaSnap v(?<version>[\d\.]+)"
  $versPage.Content -match $re
  $version = $matches.version

  @{
    Url32             = $Url32
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

Update-Package -ChecksumFor none -NoCheckUrl
