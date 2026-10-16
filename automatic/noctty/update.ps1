Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function global:au_GetLatest {
  $release = Get-GitHubRelease amanthanvi noctty
  $version = $release.tag_name.TrimStart('v')

  $url64    = $release.assets | Where-Object { $_.name -eq "noctty-$version-windows-x64-setup.exe" }   | Select-Object -ExpandProperty browser_download_url -First 1
  $urlArm64 = $release.assets | Where-Object { $_.name -eq "noctty-$version-windows-arm64-setup.exe" } | Select-Object -ExpandProperty browser_download_url -First 1
  if (-not $url64)    { throw "No windows-x64 setup asset in amanthanvi/noctty $version" }
  if (-not $urlArm64) { throw "No windows-arm64 setup asset in amanthanvi/noctty $version" }

  # Upstream ships one checksums file per architecture.
  $sums64    = $release.assets | Where-Object { $_.name -eq 'SHA256SUMS-windows-x64.txt' }   | Select-Object -ExpandProperty browser_download_url -First 1
  $sumsArm64 = $release.assets | Where-Object { $_.name -eq 'SHA256SUMS-windows-arm64.txt' } | Select-Object -ExpandProperty browser_download_url -First 1
  if (-not $sums64)    { throw "No SHA256SUMS-windows-x64.txt in amanthanvi/noctty $version" }
  if (-not $sumsArm64) { throw "No SHA256SUMS-windows-arm64.txt in amanthanvi/noctty $version" }

  @{
    Version       = $version
    URL64         = $url64
    URLArm64      = $urlArm64
    SumsUrl64     = $sums64
    SumsUrlArm64  = $sumsArm64
    ReleaseNotes  = "https://github.com/amanthanvi/noctty/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  function Get-Sum([string]$sumsUrl, [string]$assetUrl) {
    $raw = (Invoke-WebRequest -Uri $sumsUrl -UseBasicParsing).Content
    if ($raw -is [byte[]]) { $raw = [System.Text.Encoding]::UTF8.GetString($raw) }
    $name = Split-Path -Leaf $assetUrl
    $line = $raw -split "`n" | Where-Object { $_ -match "\s\*?$([regex]::Escape($name))\s*$" } | Select-Object -First 1
    if (-not $line) { throw "No checksum for $name in $sumsUrl" }
    ($line -split '\s+')[0].ToLower()
  }

  $Latest.Checksum64    = Get-Sum $Latest.SumsUrl64 $Latest.URL64
  $Latest.ChecksumArm64 = Get-Sum $Latest.SumsUrlArm64 $Latest.URLArm64
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"         = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"    = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\`$urlArm64\s*=\s*)'.*'"      = "`${1}'$($Latest.URLArm64)'"
      "(?i)(^\`$checksumArm64\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumArm64)'"
    }
    'noctty.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none
