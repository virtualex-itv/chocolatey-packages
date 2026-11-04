Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease pkgconf pkgconf
  $version = $release.tag_name -replace '^pkgconf-', ''

  $x86 = $release.assets | Where-Object { $_.name -eq "pkgconf-x86-$version.msi" } | Select-Object -First 1
  $x64 = $release.assets | Where-Object { $_.name -eq "pkgconf-x64-$version.msi" } | Select-Object -First 1
  $arm = $release.assets | Where-Object { $_.name -eq "pkgconf-arm64-$version.msi" } | Select-Object -First 1
  if (-not $x86 -or -not $x64 -or -not $arm) {
    if (Test-ReleaseAssetsPending $release) { return 'ignore' }
    throw "Missing MSI asset (x86: $([bool]$x86), x64: $([bool]$x64), arm64: $([bool]$arm)) in pkgconf/pkgconf $version"
  }

  @{
    Version      = $version
    URL32        = $x86.browser_download_url
    Digest32     = $x86.digest
    URL64        = $x64.browser_download_url
    Digest64     = $x64.digest
    URLArm64     = $arm.browser_download_url
    DigestArm64  = $arm.digest
    ReleaseNotes = "https://github.com/pkgconf/pkgconf/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32    = Get-Sha256 $Latest.URL32 $Latest.Digest32
  $Latest.Checksum64    = Get-Sha256 $Latest.URL64 $Latest.Digest64
  $Latest.ChecksumArm64 = Get-Sha256 $Latest.URLArm64 $Latest.DigestArm64
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url32\s*=\s*)'.*'"          = "`${1}'$($Latest.URL32)'"
      "(?i)(^\`$checksum32\s*=\s*)'.*'"     = "`${1}'$($Latest.Checksum32)'"
      "(?i)(^\`$url64\s*=\s*)'.*'"          = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"     = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\`$urlArm64\s*=\s*)'.*'"       = "`${1}'$($Latest.URLArm64)'"
      "(?i)(^\`$checksumArm64\s*=\s*)'.*'"  = "`${1}'$($Latest.ChecksumArm64)'"
    }
    'pkgconf.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
