Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease observIQ bindplane-otel-collector
  $version = $release.tag_name.TrimStart('v')

  $x64 = $release.assets | Where-Object { $_.name -eq 'observiq-otel-collector.msi' } | Select-Object -First 1
  $arm = $release.assets | Where-Object { $_.name -eq 'observiq-otel-collector-arm64.msi' } | Select-Object -First 1
  if (-not $x64 -or -not $arm) {
    if (Test-ReleaseAssetsPending $release) { return 'ignore' }
    throw "Missing MSI asset (x64: $([bool]$x64), arm64: $([bool]$arm)) in observIQ/bindplane-otel-collector $version"
  }

  @{
    Version      = $version
    URL64        = $x64.browser_download_url
    Digest64     = $x64.digest
    URLArm64     = $arm.browser_download_url
    DigestArm64  = $arm.digest
    ReleaseNotes = "https://github.com/observIQ/bindplane-otel-collector/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64    = Get-Sha256 $Latest.URL64 $Latest.Digest64
  $Latest.ChecksumArm64 = Get-Sha256 $Latest.URLArm64 $Latest.DigestArm64
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"          = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"     = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\`$urlArm64\s*=\s*)'.*'"       = "`${1}'$($Latest.URLArm64)'"
      "(?i)(^\`$checksumArm64\s*=\s*)'.*'"  = "`${1}'$($Latest.ChecksumArm64)'"
    }
    'bindplane-otel-collector.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
