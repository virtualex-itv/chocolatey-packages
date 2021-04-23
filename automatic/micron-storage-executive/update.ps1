Import-Module AU

$releases = 'https://www.micron.com/products/ssd/storage-executive-software'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = 'windows.exe'
  $Url64 = $download_page.links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href

  $re = '((\d+)\.(\d+)\.(\d+)\.(\d+))'
  $version = $download_page.Content -match $re | Out-Null
  $version = $Matches[0]

  $checksumType = 'sha256'
  $checksum64 = Get-RemoteChecksum -Algorithm $checksumType -Url $Url64

  @{
    Url64             = $Url64
    Version           = $version
    Checksum64        = $checksum64
    ChecksumType64    = $checksumType
  }
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
          "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      }
  }
}

Update-Package -ChecksumFor none
