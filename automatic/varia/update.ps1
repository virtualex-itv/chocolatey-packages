Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease giantpinkrobots varia

  # Tags are vYYYY.M.D with an optional -N rebuild suffix; NuGet reads -N as a prerelease, so use a 4th segment.
  if ($release.tag_name -notmatch '^v?(?<ymd>\d+\.\d+\.\d+)(?:-(?<rev>\d+))?$') { throw "Unexpected Varia tag '$($release.tag_name)'" }
  $version = if ($Matches['rev']) { "$($Matches['ymd']).$($Matches['rev'])" } else { $Matches['ymd'] }

  $asset = $release.assets | Where-Object { $_.name -eq 'varia-windows-setup-amd64.exe' } | Select-Object -First 1
  if (-not $asset) { throw "No asset 'varia-windows-setup-amd64.exe' in giantpinkrobots/varia $($release.tag_name)" }

  @{
    Version      = $version
    URL64        = $asset.browser_download_url
    Digest       = $asset.digest
    ReleaseNotes = "https://github.com/giantpinkrobots/varia/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = Get-Sha256 $Latest.URL64 $Latest.Digest
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
    'varia.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none
