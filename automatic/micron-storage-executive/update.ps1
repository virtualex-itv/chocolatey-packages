Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$releases = 'https://www.micron.com/products/ssd/storage-executive-software'

# Page links only the msecli CLI now, so pin the still-hosted GUI installer.
# A bare 'windows.exe' match would pick up msecli-windows.exe instead.
$fallbackUrl = 'https://assets.micron.com/adobe/assets/urn:aaid:aem:cbf18087-f8b5-4434-910b-15953998aa84/renditions/original/as/storageexecutive-windows.exe'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $Url64 = $download_page.links |
    Where-Object { $_.href -match 'storageexecutive-windows\.exe' } |
    Select-Object -First 1 -ExpandProperty href
  if (-not $Url64) { $Url64 = $fallbackUrl }

  # Anchor on the Windows Storage Executive phrase - the page also lists Linux and msecli.
  $re = '(?i)Windows[^<]{0,40}?Storage Executive[^<]{0,20}version[^\d]{0,12}([\d\.]+)'
  if ($download_page.Content -notmatch $re) {
    throw "Could not find the Windows Storage Executive version on $releases"
  }

  # Match NuGet's nupkg filename so GitReleases can find it (11.08.082025.00 -> 11.8.82025).
  $version = ConvertTo-NuGetVersion $Matches[1]

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
