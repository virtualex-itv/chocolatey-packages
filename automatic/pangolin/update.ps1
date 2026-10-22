Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$release = Get-GitHubRelease fosrl windows

function global:au_GetLatest {
  $version = $release.tag_name
  $asset = $release.assets | Where-Object { $_.name -match 'pangolin-amd64-.*\.msi$' } | Select-Object -First 1
  if (-not $asset) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset matching 'pangolin-amd64-*.msi' in fosrl/windows $($release.tag_name)" }
  $Url64 = $asset.browser_download_url

  return @{
    Version = $version
    Url64   = $Url64
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64 -Algorithm 'sha256'
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.Url64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
