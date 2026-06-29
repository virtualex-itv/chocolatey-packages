Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

# Version detection: read the latest GitHub release name (e.g. "Hermes Agent v0.17.0
# (v2026.6.19)"). The old public download page (hermes-agent.nousresearch.com/desktop)
# now 308-redirects to /, which Invoke-WebRequest won't follow cleanly, so the releases
# API is the stable source. The download URL is always-latest (no per-version URL
# exists), so checksum gets recomputed every time a new version is reported.
$releasesApi = 'https://api.github.com/repos/NousResearch/hermes-agent/releases/latest'

function global:au_GetLatest {
  $headers = @{}
  if ($env:github_api_key) { $headers.Authorization = "Bearer $env:github_api_key" }

  $release = Invoke-RestMethod -Uri $releasesApi -Headers $headers
  if ($release.name -notmatch 'Hermes Agent v(\d+\.\d+(?:\.\d+)?)') {
    throw 'Could not find Hermes Agent version in the latest GitHub release name'
  }
  $version = $Matches[1]

  # Normalize to match NuGet's on-disk nupkg filename so AU's GitReleases plugin can find it.
  $version = ConvertTo-NuGetVersion $version

  @{
    Version = $version
    URL64   = 'https://hermes-assets.nousresearch.com/Hermes-Setup.exe'
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64     = Get-RemoteChecksum $Latest.URL64 -Algorithm SHA256
  $Latest.ChecksumType64 = 'sha256'
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.URL64)'"
      "(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
  }
}

Update-Package -ChecksumFor none
