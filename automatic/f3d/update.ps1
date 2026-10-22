Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease f3d-app f3d
  $version = $release.tag_name.TrimStart('v')

  $asset = $release.assets | Where-Object { $_.name -like 'F3D-*-Windows-x86_64.exe' } | Select-Object -First 1
  if (-not $asset) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset matching 'F3D-*-Windows-x86_64.exe' in f3d-app/f3d $version" }

  $assetRt = $release.assets | Where-Object { $_.name -like 'F3D-*-Windows-x86_64-raytracing.exe' } | Select-Object -First 1
  if (-not $assetRt) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset matching 'F3D-*-Windows-x86_64-raytracing.exe' in f3d-app/f3d $version" }

  @{
    Version      = $version
    URL64        = $asset.browser_download_url
    Digest       = $asset.digest
    URL64Rt      = $assetRt.browser_download_url
    DigestRt     = $assetRt.digest
    ReleaseNotes = "https://github.com/f3d-app/f3d/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64   = Get-Sha256 $Latest.URL64 $Latest.Digest
  $Latest.Checksum64Rt = Get-Sha256 $Latest.URL64Rt $Latest.DigestRt
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"                = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"           = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\`$url64Raytracing\s*=\s*)'.*'"      = "`${1}'$($Latest.URL64Rt)'"
      "(?i)(^\`$checksum64Raytracing\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64Rt)'"
    }
    'f3d.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
