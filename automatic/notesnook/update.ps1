Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $headers = @{}
  if ($env:github_api_key) { $headers.Authorization = "Bearer $env:github_api_key" }

  # The repo also publishes Android/iOS releases (tags like 3.4.15-android) and they can be the "latest" release - take desktop tags only
  $releases = Invoke-RestMethod -Uri 'https://api.github.com/repos/streetwriters/notesnook/releases?per_page=30' -Headers $headers
  $release = $releases | Where-Object { $_.tag_name -match '^v\d+\.\d+\.\d+$' -and -not $_.prerelease -and -not $_.draft } | Select-Object -First 1
  if (-not $release) { throw 'No desktop release (tag vX.Y.Z) found in streetwriters/notesnook' }
  $version = $release.tag_name.TrimStart('v')

  $x64 = $release.assets | Where-Object { $_.name -eq 'notesnook_win_x64.exe' } | Select-Object -First 1
  $arm = $release.assets | Where-Object { $_.name -eq 'notesnook_win_arm64.exe' } | Select-Object -First 1
  if (-not $x64 -or -not $arm) {
    if (Test-ReleaseAssetsPending $release) { return 'ignore' }
    throw "Missing installer asset (x64: $([bool]$x64), arm64: $([bool]$arm)) in streetwriters/notesnook $version"
  }

  @{
    Version      = $version
    URL64        = $x64.browser_download_url
    Digest64     = $x64.digest
    URLArm64     = $arm.browser_download_url
    DigestArm64  = $arm.digest
    ReleaseNotes = "https://github.com/streetwriters/notesnook/releases/tag/$($release.tag_name)"
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
    'notesnook.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
