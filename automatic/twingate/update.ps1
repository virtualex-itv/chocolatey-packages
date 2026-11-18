Import-Module Chocolatey-AU

function global:au_GetLatest {
  # Twingate's own update API answers "which update does this client get next", not "latest":
  # asking from 2020.1.1 returns an intermediate build. Follow the chain from the packaged
  # version until it reports no update, the way the app's updater does.
  $nuspec = [xml](Get-Content "$PSScriptRoot\twingate.nuspec" -Raw)
  $chocoVersion = $nuspec.package.metadata.version
  for ($hop = 0; $hop -lt 10; $hop++) {
    $response = Invoke-RestMethod -Uri "https://corp.twingate.com/api/versions/windows/?app_version=$chocoVersion" -UseBasicParsing
    $next = $response.data.downloadable_url
    if (-not $next) { break }
    if ($next -notmatch '/versions/(\d{4}\.\d+\.\d+)/') { throw "Unexpected Twingate download URL: $next" }
    if ([version]$Matches[1] -le [version]$chocoVersion) { break }
    $chocoVersion = $Matches[1]
  }

  $url64 = "https://binaries.twingate.com/client/windows/versions/$chocoVersion/TwingateWindowsInstaller.msi"

  return @{
    Version        = $chocoVersion
    Url64          = $url64
    ChecksumType64 = 'sha256'
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = Get-RemoteChecksum -Url $Latest.Url64 -Algorithm 'sha256'
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"          = "`${1}'$($Latest.Url64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"     = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\`$checksumType64\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumType64)'"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
