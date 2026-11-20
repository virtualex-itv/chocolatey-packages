Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$history_page  = 'https://www.stardock.com/products/start11/history'
$download_page = 'https://www.stardock.com/products/start11/download-trial'

# Majors the history page does not list yet: version comes from the installer, cached by ETag + Content-Length in .\info
$installerVersionMajors = @(3)

function Get-InstallerVersion([string]$stream, [string]$url) {
  $request = [System.Net.WebRequest]::CreateDefault($url)
  $request.Method = 'HEAD'
  $response = $request.GetResponse()
  $etag = $response.Headers.Get('ETag'); $length = $response.ContentLength.ToString()
  $response.Dispose()

  # info: one line per stream, stream|ETag|Content-Length|Version
  $infoFile = Join-Path $PSScriptRoot 'info'
  $lines = @(if (Test-Path $infoFile) { Get-Content $infoFile -Encoding UTF8 | Where-Object { $_ } })
  $cached = $lines | Where-Object { $_ -like "$stream|*" } | Select-Object -First 1
  if ($cached) {
    $p = $cached -split '\|'
    if ($p[1] -eq $etag -and $p[2] -eq $length) { return $p[3] }
  }

  $dest = Join-Path $env:TEMP (Split-Path -Leaf $url)
  Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
  $version = (Get-Command $dest).FileVersionInfo.ProductVersion
  Remove-Item $dest -Force -ErrorAction SilentlyContinue
  if (-not $version) { throw "Could not read a version from $url" }
  $version = $version.Trim()

  $lines = @($lines | Where-Object { $_ -notlike "$stream|*" }) + "$stream|$etag|$length|$version" | Sort-Object
  $lines | Set-Content $infoFile -Encoding UTF8
  return $version
}

function global:au_GetLatest {
  # The installer moves between Stardock's two CDNs and changes path per major version (.../v2/Start11v2_Setup.exe)
  $urlPattern = 'https?://[^"''\s<>]+Start11[^"''\s<>]*\.exe'
  $page = Get-RetryWebContent $download_page -MustMatch $urlPattern
  $urls = [regex]::Matches($page, $urlPattern) | ForEach-Object Value | Select-Object -Unique

  $content = $null
  $streams = @{}
  foreach ($major in 2, 3) {
    $Url = $urls | Where-Object { $_ -match "Start11v$($major)_" } | Select-Object -First 1
    if (-not $Url) { throw "Could not find a Start11 v$major installer URL on $download_page" }

    if ($major -in $installerVersionMajors) {
      $version = Get-InstallerVersion "$major" $Url
    } else {
      # Entries look like "Start11 v2.81", "Start11 2.74" or "Start11 v2 (2.82)"
      $pattern = "Start11 (?:v$major \()?v?(?<version>$major(\.\d+)+)\)?(?<beta> Beta)?"
      if (-not $content) { $content = Get-RetryWebContent $history_page -MustMatch $pattern }
      $version = $null
      foreach ($m in [regex]::Matches($content, $pattern)) {
        if (-not $m.Groups['beta'].Success) { $version = $m.Groups['version'].Value; break }
      }
      if (-not $version) { throw "Could not find a non-beta Start11 $major.x version on $history_page" }

      # Stardock's minor is a 2-digit field with trailing zeros dropped (2.7 = 2.70, 2.8 =
      # 2.80). Pad it or 2.8 normalizes to 2.8.0, which NuGet sorts below the shipped 2.74.0.
      if ($version -match '^(\d+)\.(\d)$') { $version = "$($Matches[1]).$($Matches[2])0" }

      # Match NuGet's nupkg filename so GitReleases can find it (2.74 -> 2.74.0).
      $version = ConvertTo-NuGetVersion $version
    }

    $streams["$major"] = @{
      Url32          = $Url
      Version        = $version
      ChecksumType32 = 'sha256'
    }
  }

  @{ Streams = $streams }
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

Update-Package -ChecksumFor none -NoReadme
