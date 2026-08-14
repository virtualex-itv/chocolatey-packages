Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$releases = 'https://www.micron.com/products/ssd/storage-executive-software'

# Page links only the msecli CLI now, so pin the still-hosted GUI installer.
# A bare 'windows.exe' match would pick up msecli-windows.exe instead.
$fallbackUrl = 'https://assets.micron.com/adobe/assets/urn:aaid:aem:cbf18087-f8b5-4434-910b-15953998aa84/renditions/original/as/storageexecutive-windows.exe'

function global:au_GetLatest {
  # Anchor on the Windows Storage Executive phrase - the page also lists Linux and msecli.
  $re = '(?i)Windows[^<]{0,40}?Storage Executive[^<]{0,20}version[^\d]{0,12}([\d\.]+)'
  $ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'

  # Micron intermittently serves the page without the version block; retry before failing.
  $version = $null
  $download_page = $null
  for ($i = 1; $i -le 3 -and -not $version; $i++) {
    if ($i -gt 1) { Start-Sleep -Seconds ($i * 3) }
    try {
      $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing -UserAgent $ua
      if ($download_page.Content -match $re) { $version = $Matches[1] }
    } catch { }
  }
  if (-not $version) { throw "Could not find the Windows Storage Executive version on $releases" }

  $Url64 = $download_page.links |
    Where-Object { $_.href -match 'storageexecutive-windows\.exe' } |
    Select-Object -First 1 -ExpandProperty href
  if (-not $Url64) { $Url64 = $fallbackUrl }

  # Match NuGet's nupkg filename so GitReleases can find it (11.08.082025.00 -> 11.8.82025).
  $version = ConvertTo-NuGetVersion $version

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
