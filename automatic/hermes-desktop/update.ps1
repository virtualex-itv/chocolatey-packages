Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

# Version detection: scrape the public download page. The download URL is always-latest
# (no per-version URL exists), so checksum gets recomputed every time the page reports
# a new version.
$releases = 'https://hermes-agent.nousresearch.com/desktop'

function global:au_GetLatest {
  $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  if ($page.Content -notmatch 'Hermes Agent v(\d+\.\d+(?:\.\d+)?)') {
    throw 'Could not find Hermes Agent version on the page'
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
