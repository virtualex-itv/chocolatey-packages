Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$releases = 'https://support.creative.com/Downloads/searchdownloads.aspx?filename=CreativeApp&ShowAll=1'

function Test-Downloadable([string]$Url) {
  try {
    $r = [System.Net.HttpWebRequest]::Create($Url)
    $r.Method = 'HEAD'; $r.UserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
    $resp = $r.GetResponse(); $resp.Dispose(); return $true
  } catch { return $false }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  # Extract version from filename pattern like CreativeAppSetup_1.23.04.00.exe
  $re = 'CreativeAppSetup_(\d+)\.(\d+)\.(\d+)\.(\d+)\.exe'
  if ($download_page.Content -match $re) {
    $versionParts = @($Matches[1], $Matches[2], $Matches[3], $Matches[4])
    # Match NuGet's nupkg filename so GitReleases can find it (1.24.0.0 -> 1.24.0).
    $version = ConvertTo-NuGetVersion "$($versionParts[0]).$([int]$versionParts[1]).$([int]$versionParts[2]).$([int]$versionParts[3])"
    # Version for URL: 1.23.04.00 (keep the original format with leading zeros)
    $urlVersion = "$($versionParts[0]).$($versionParts[1]).$($versionParts[2]).$($versionParts[3])"
  } else {
    throw "Could not find version in download page"
  }

  $Url32 = "https://files.creative.com/creative/bin/apps/swureleases/win/creativeapp/release/CreativeAppSetup_$urlVersion.exe"
  $ChecksumType = 'sha256'

  # Creative lists a release on the support page before the installer reaches the CDN.
  # Stay on the packaged version until the file is actually downloadable.
  if (-not (Test-Downloadable $Url32)) {
    $nuspec  = Get-ChildItem $PSScriptRoot -Filter '*.nuspec' | Select-Object -First 1
    $current = ([xml](Get-Content $nuspec.FullName)).package.metadata.version
    $installed = Select-String -Path "$PSScriptRoot\tools\chocolateyInstall.ps1" -Pattern "^\`$url\s*=\s*'([^']+)'"
    Write-Warning "Creative lists $version but $Url32 is not downloadable yet; keeping $current."
    return @{
      Url32          = $installed.Matches[0].Groups[1].Value
      Version        = $current
      ChecksumType32 = $ChecksumType
    }
  }

  @{
    Url32          = $Url32
    Version        = $version
    ChecksumType32 = $ChecksumType
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32 -Algorithm $Latest.ChecksumType32
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.Url32)'"
      "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
      "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
    }
  }
}

Update-Package -ChecksumFor none
