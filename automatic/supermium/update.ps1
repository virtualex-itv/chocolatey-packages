Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease win32ss supermium

  # Tags are v<Chromium major>-r<revision>[.<patch>], e.g. v150-r2.01 -> 150.2.1.
  if ($release.tag_name -notmatch '^v(?<major>\d+)-r(?<rev>\d+)(?:\.(?<patch>\d+))?$') { throw "Unexpected Supermium tag '$($release.tag_name)'" }
  $version = '{0}.{1}.{2}' -f $Matches['major'], $Matches['rev'], [int]$(if ($Matches['patch']) { $Matches['patch'] } else { '0' })
  $major = $Matches['major']

  $asset32 = $release.assets | Where-Object { $_.name -eq "supermium_${major}_32_setup.exe" } | Select-Object -First 1
  if (-not $asset32) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset 'supermium_${major}_32_setup.exe' in win32ss/supermium $($release.tag_name)" }
  # The 64-bit build for Windows 10 and 11; the plain 64-bit setup only adds a DirectWrite shim for Windows 7/8.
  $asset64 = $release.assets | Where-Object { $_.name -eq "supermium_${major}_64_setup_win10_11.exe" } | Select-Object -First 1
  if (-not $asset64) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset 'supermium_${major}_64_setup_win10_11.exe' in win32ss/supermium $($release.tag_name)" }

  @{
    Version      = $version
    URL32        = $asset32.browser_download_url
    Digest32     = $asset32.digest
    URL64        = $asset64.browser_download_url
    Digest64     = $asset64.digest
    ReleaseNotes = "https://github.com/win32ss/supermium/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-Sha256 $Latest.URL32 $Latest.Digest32
  $Latest.Checksum64 = Get-Sha256 $Latest.URL64 $Latest.Digest64
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url32\s*=\s*)'.*'"      = "`${1}'$($Latest.URL32)'"
      "(?i)(^\`$checksum32\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum32)'"
      "(?i)(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
    'supermium.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
