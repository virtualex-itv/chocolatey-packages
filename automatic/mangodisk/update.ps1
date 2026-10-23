Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease harry0703 MangoDisk
  $version = $release.tag_name.TrimStart('v')

  $asset = $release.assets | Where-Object { $_.name -match '^MangoDisk-[0-9.]+-windows\.exe$' } | Select-Object -First 1
  if (-not $asset) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset matching '^MangoDisk-[0-9.]+-windows\.exe$' in harry0703/MangoDisk $version" }

  @{
    Version      = $version
    URL64        = $asset.browser_download_url
    Digest       = $asset.digest
    ReleaseNotes = "https://github.com/harry0703/MangoDisk/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = Get-Sha256 $Latest.URL64 $Latest.Digest
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
    'mangodisk.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
