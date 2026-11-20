Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

# OpenTofu patches the current and the previous minor in parallel (1.12.x next to 1.13.x): one stream per minor.
$StreamCount = 2

function Get-LatestPerMinor {
  $headers = @{}
  if ($env:github_api_key) { $headers.Authorization = "token $env:github_api_key" }
  $releases = Invoke-RestMethod 'https://api.github.com/repos/opentofu/opentofu/releases?per_page=50' -Headers $headers
  $releases | Where-Object { -not $_.prerelease -and -not $_.draft -and $_.tag_name -match '^v\d+\.\d+\.\d+$' } |
    Group-Object { ($_.tag_name.TrimStart('v') -split '\.')[0..1] -join '.' } |
    Sort-Object { [version]$_.Name } -Descending |
    Select-Object -First $StreamCount |
    ForEach-Object { $_.Group | Sort-Object { [version]$_.tag_name.TrimStart('v') } -Descending | Select-Object -First 1 }
}

function global:au_GetLatest {
  $streams = [ordered]@{}
  foreach ($release in Get-LatestPerMinor) {
    $version = $release.tag_name.TrimStart('v')
    $minor = ($version -split '\.')[0..1] -join '.'

    $assets = @{}
    foreach ($arch in '386', 'amd64', 'arm64') {
      $name = "tofu_${version}_windows_$arch.zip"
      $asset = $release.assets | Where-Object { $_.name -eq $name } | Select-Object -First 1
      # Windows ARM64 builds start with 1.13; older lines give ARM64 the amd64 build (runs under x64 emulation)
      if (-not $asset -and $arch -eq 'arm64' -and [version]$version -lt [version]'1.13.0') { $asset = $assets['amd64'] }
      if (-not $asset) { if (Test-ReleaseAssetsPending $release) { $assets = $null; break }; throw "No asset '$name' in opentofu/opentofu $version" }
      $assets[$arch] = $asset
    }
    if (-not $assets) { $streams[$minor] = 'ignore'; continue }

    $streams[$minor] = @{
      Version      = $version
      URL32        = $assets['386'].browser_download_url
      Digest32     = $assets['386'].digest
      URL64        = $assets['amd64'].browser_download_url
      Digest64     = $assets['amd64'].digest
      URLArm64     = $assets['arm64'].browser_download_url
      DigestArm64  = $assets['arm64'].digest
      ReleaseNotes = "https://github.com/opentofu/opentofu/releases/tag/$($release.tag_name)"
    }
  }
  @{ Streams = $streams }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32    = Get-Sha256 $Latest.URL32 $Latest.Digest32
  $Latest.Checksum64    = Get-Sha256 $Latest.URL64 $Latest.Digest64
  $Latest.ChecksumArm64 = Get-Sha256 $Latest.URLArm64 $Latest.DigestArm64
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url32\s*=\s*)'.*'"         = "`${1}'$($Latest.URL32)'"
      "(?i)(^\`$checksum32\s*=\s*)'.*'"    = "`${1}'$($Latest.Checksum32)'"
      "(?i)(^\`$url64\s*=\s*)'.*'"         = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"    = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\`$urlArm64\s*=\s*)'.*'"      = "`${1}'$($Latest.URLArm64)'"
      "(?i)(^\`$checksumArm64\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumArm64)'"
    }
    'opentofu.portable.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
