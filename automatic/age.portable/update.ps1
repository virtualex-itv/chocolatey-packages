Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease FiloSottile age
  $version = $release.tag_name.TrimStart('v')

  $asset64 = $release.assets | Where-Object { $_.name -like 'age-v*-windows-amd64.zip' } | Select-Object -First 1
  if (-not $asset64) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset matching 'age-v*-windows-amd64.zip' in FiloSottile/age $version" }

  $assetArm64 = $release.assets | Where-Object { $_.name -like 'age-v*-windows-arm64.zip' } | Select-Object -First 1
  if (-not $assetArm64) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset matching 'age-v*-windows-arm64.zip' in FiloSottile/age $version" }

  @{
    Version       = $version
    URL64         = $asset64.browser_download_url
    Digest64      = $asset64.digest
    URLArm64      = $assetArm64.browser_download_url
    DigestArm64   = $assetArm64.digest
    ReleaseNotes  = "https://github.com/FiloSottile/age/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64    = Get-Sha256 $Latest.URL64 $Latest.Digest64
  $Latest.ChecksumArm64 = Get-Sha256 $Latest.URLArm64 $Latest.DigestArm64
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"         = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"    = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\`$urlArm64\s*=\s*)'.*'"      = "`${1}'$($Latest.URLArm64)'"
      "(?i)(^\`$checksumArm64\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumArm64)'"
    }
    'age.portable.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
