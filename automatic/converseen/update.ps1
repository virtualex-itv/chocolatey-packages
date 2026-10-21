Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease Faster3ck Converseen
  $version = $release.tag_name.TrimStart('v')

  $asset64 = $release.assets | Where-Object { $_.name -like 'Converseen-*-win64-setup.msi' } | Select-Object -First 1
  if (-not $asset64) { throw "No asset matching 'Converseen-*-win64-setup.msi' in Faster3ck/Converseen $version" }

  @{
    Version      = $version
    URL64        = $asset64.browser_download_url
    Digest64     = $asset64.digest
    ReleaseNotes = "https://github.com/Faster3ck/Converseen/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = Get-Sha256 $Latest.URL64 $Latest.Digest64
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
    'converseen.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none
