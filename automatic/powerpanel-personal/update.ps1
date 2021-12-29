Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.cyberpowersystems.com/products/software/power-panel-personal/'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '.exe'
  $Url32 = $download_page.Links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href
  $version = $Url32 -split '_v|.exe' | Select-Object -First 1 -Skip 1
  $ChecksumType = 'sha256'

  $re = 'windows-'
  $product_url = $download_page.Links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href
  $product_page = Invoke-WebRequest -Uri $product_url -UseBasicParsing

  $re = 'UM_'
  $DocsUrl = $product_page.links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href

  $re = 'RN_'
  $ReleaseNotes = $product_page.links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href

  @{
    Url32             = $Url32
    Version           = $version
    ChecksumType32    = $ChecksumType
    DocsUrl           = $DocsUrl
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
  Update-Metadata -key "docsUrl" -value $Latest.DocsUrl
  Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor none
