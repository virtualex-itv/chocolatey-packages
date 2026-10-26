Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease LesFerch WinSetView
  $version = $release.tag_name.TrimStart('v')

  $asset = $release.assets | Where-Object { $_.name -eq 'WinSetView-Setup.exe' } | Select-Object -First 1
  if (-not $asset) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset named 'WinSetView-Setup.exe' in LesFerch/WinSetView $version" }

  @{
    Version = $version
    URL32   = $asset.browser_download_url
    Digest  = $asset.digest
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-Sha256 $Latest.URL32 $Latest.Digest
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url\s*=\s*)'.*'"      = "`${1}'$($Latest.URL32)'"
      "(?i)(^\`$checksum\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum32)'"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
