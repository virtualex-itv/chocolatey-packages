Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease DISTRHO Cardinal
  if ($release.tag_name -notmatch '^(?<yy>\d+)\.(?<mm>\d+)$') { throw "Unexpected Cardinal tag '$($release.tag_name)'" }
  $version = "$($Matches['yy']).$([int]$Matches['mm']).0"

  $asset = $release.assets | Where-Object { $_.name -like 'Cardinal-win64-*-installer.exe' } | Select-Object -First 1
  if (-not $asset) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset matching 'Cardinal-win64-*-installer.exe' in DISTRHO/Cardinal $version" }

  @{
    Version      = $version
    URL64        = $asset.browser_download_url
    Digest       = $asset.digest
    ReleaseNotes = "https://github.com/DISTRHO/Cardinal/releases/tag/$($release.tag_name)"
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
    'cardinal.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
