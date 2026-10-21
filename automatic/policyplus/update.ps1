Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  $release = Get-GitHubRelease Fleex255 PolicyPlus
  if ($release.tag_name -notmatch '^(?<month>[A-Za-z]+)(?<year>\d{4})$') { throw "Unexpected tag format '$($release.tag_name)' in Fleex255/PolicyPlus" }
  $month = [datetime]::ParseExact($Matches['month'], 'MMMM', [cultureinfo]'en-US').Month
  $version = "$($Matches['year']).$month"

  $asset = $release.assets | Where-Object { $_.name -eq 'PolicyPlus.exe' } | Select-Object -First 1
  if (-not $asset) { throw "No asset matching 'PolicyPlus.exe' in Fleex255/PolicyPlus $version" }

  @{
    Version      = $version
    URL32        = $asset.browser_download_url
    Digest       = $asset.digest
    ReleaseNotes = "https://github.com/Fleex255/PolicyPlus/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-Sha256 $Latest.URL32 $Latest.Digest
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url\s*=\s*)'.*'"      = "`${1}'$($Latest.URL32)'"
      "(?i)(^\`$checksum\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum32)'"
    }
    'policyplus.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none