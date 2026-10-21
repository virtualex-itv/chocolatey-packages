Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease pavlobu deskreen
  $version = $release.tag_name.TrimStart('v')

  $asset32 = $release.assets | Where-Object { $_.name -like 'deskreen-ce-*-ia32.msi' } | Select-Object -First 1
  if (-not $asset32) { throw "No asset matching 'deskreen-ce-*-ia32.msi' in pavlobu/deskreen $version" }

  $asset64 = $release.assets | Where-Object { $_.name -like 'deskreen-ce-*-x64.msi' } | Select-Object -First 1
  if (-not $asset64) { throw "No asset matching 'deskreen-ce-*-x64.msi' in pavlobu/deskreen $version" }

  @{
    Version      = $version
    URL32        = $asset32.browser_download_url
    Digest32     = $asset32.digest
    URL64        = $asset64.browser_download_url
    Digest64     = $asset64.digest
    ReleaseNotes = "https://github.com/pavlobu/deskreen/releases/tag/$($release.tag_name)"
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
    'deskreen.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none
