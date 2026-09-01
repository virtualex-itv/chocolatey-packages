Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function global:au_GetLatest {
  $release = Get-GitHubRelease BetterDiscord cli
  $version = $release.tag_name.TrimStart('v')

  $url64    = $release.assets | Where-Object { $_.name -like 'bdcli_*_windows_amd64.zip' } | Select-Object -ExpandProperty browser_download_url -First 1
  $urlArm64 = $release.assets | Where-Object { $_.name -like 'bdcli_*_windows_arm64.zip' } | Select-Object -ExpandProperty browser_download_url -First 1
  if (-not $url64)    { throw "No windows_amd64 asset in BetterDiscord/cli $version" }
  if (-not $urlArm64) { throw "No windows_arm64 asset in BetterDiscord/cli $version" }

  # Upstream ships one checksums file covering every asset.
  $sumsUrl = $release.assets | Where-Object { $_.name -eq 'bdcli_checksums.txt' } | Select-Object -ExpandProperty browser_download_url -First 1
  if (-not $sumsUrl) { throw "No bdcli_checksums.txt in BetterDiscord/cli $version" }

  @{
    Version      = $version
    URL64        = $url64
    URLArm64     = $urlArm64
    ChecksumsUrl = $sumsUrl
    ReleaseNotes = "https://github.com/BetterDiscord/cli/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  $raw = (Invoke-WebRequest -Uri $Latest.ChecksumsUrl -UseBasicParsing).Content
  if ($raw -is [byte[]]) { $raw = [System.Text.Encoding]::UTF8.GetString($raw) }

  function Get-Sum([string]$assetUrl) {
    $name = Split-Path -Leaf $assetUrl
    $line = $raw -split "`n" | Where-Object { $_ -match "\s$([regex]::Escape($name))\s*$" } | Select-Object -First 1
    if (-not $line) { throw "No checksum for $name in bdcli_checksums.txt" }
    ($line -split '\s+')[0].ToLower()
  }

  $Latest.Checksum64    = Get-Sum $Latest.URL64
  $Latest.ChecksumArm64 = Get-Sum $Latest.URLArm64
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"         = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"    = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\`$urlArm64\s*=\s*)'.*'"      = "`${1}'$($Latest.URLArm64)'"
      "(?i)(^\`$checksumArm64\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumArm64)'"
    }
    'betterdiscord-cli.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none
