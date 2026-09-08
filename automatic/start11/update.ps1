Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$history_page  = 'https://www.stardock.com/products/start11/history'
$download_page = 'https://www.stardock.com/products/start11/download-trial'

function global:au_GetLatest {
  $pattern = 'Start11 v?(?<version>\d+(\.\d+)+)(?<beta> Beta)?'

  $content = Get-RetryWebContent $history_page -MustMatch $pattern
  $version = $null
  foreach ($m in [regex]::Matches($content, $pattern)) {
    if (-not $m.Groups['beta'].Success) { $version = $m.Groups['version'].Value; break }
  }
  if (-not $version) { throw "Could not find a non-beta Start11 version on $history_page" }

  # Stardock's minor is a 2-digit field with trailing zeros dropped (2.7 = 2.70, 2.8 =
  # 2.80). Pad it or 2.8 normalizes to 2.8.0, which NuGet sorts below the shipped 2.74.0.
  if ($version -match '^(\d+)\.(\d)$') { $version = "$($Matches[1]).$($Matches[2])0" }

  # Match NuGet's nupkg filename so GitReleases can find it (2.74 -> 2.74.0).
  $version = ConvertTo-NuGetVersion $version

  # The installer moves between Stardock's two CDNs and changes path per major version,
  # so scrape the current URL instead of hardcoding one.
  $urlPattern = 'https?://[^"''\s<>]+Start11[^"''\s<>]*\.exe'
  $page = Get-RetryWebContent $download_page -MustMatch $urlPattern
  $Url  = ([regex]::Match($page, $urlPattern)).Value
  if (-not $Url) { throw "Could not find a Start11 installer URL on $download_page" }

  @{
    Url32          = $Url
    Version        = $version
    ChecksumType32 = 'sha256'
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
