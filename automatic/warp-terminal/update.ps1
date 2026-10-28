Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$warpVersionPattern = '^v0\.(\d{4})\.(\d{2})\.(\d{2})\.(\d{2})\.(\d{2})\.stable_(\d+)$'

function ParseWarpVersion($v) {
  if ($v -match $warpVersionPattern) {
    [PSCustomObject]@{
      FullVersion = $v
      # SortKey: concatenate all date/time/build fields as zero-padded string for lexical sort
      SortKey     = '{0}{1}{2}{3}{4}{5:D2}' -f $Matches[1], $Matches[2], $Matches[3], $Matches[4], $Matches[5], [int]$Matches[6]
      Year        = $Matches[1]
      Month       = $Matches[2]
      Day         = $Matches[3]
      Hour        = $Matches[4]
      Minute      = $Matches[5]
      StableBuild = $Matches[6]
    }
  }
}

function global:au_GetLatest {
  # Warp's own update feed, the one the app consumes; stable.version is the current stable build
  $feed = Invoke-RestMethod -Uri 'https://releases.warp.dev/channel_versions.json' -UseBasicParsing
  $latest = ParseWarpVersion $feed.stable.version
  if (-not $latest) { throw "Unrecognized Warp stable version in channel_versions.json: '$($feed.stable.version)'" }

  Write-Host "Latest Warp version: $($latest.FullVersion) (source: releases.warp.dev)"

  # Chocolatey package version format: YYYY.M.D.HHMMBB
  # 4th octet uses integer arithmetic to avoid leading zeros (NuGet normalizes segments as integers,
  # so a string-formatted "083602" becomes "83602" in the .nupkg filename, breaking GitReleases).
  # e.g., v0.2026.01.14.08.15.stable_04 -> 2026.1.14.81504
  $fourthOctet = [int]$latest.Hour * 10000 + [int]$latest.Minute * 100 + [int]$latest.StableBuild
  $chocoVersion = '{0}.{1}.{2}.{3}' -f $latest.Year, [int]$latest.Month, [int]$latest.Day, $fourthOctet

  $url32 = "https://releases.warp.dev/stable/$($latest.FullVersion)/WarpSetup.exe"

  # Download installer to compute checksum (no sidecar checksum file available)
  $dest = "$env:TEMP\WarpSetup_$($latest.FullVersion).exe"
  Get-WebFile $url32 $dest | Out-Null
  $checksumType = 'sha256'
  $checksum32   = (Get-FileHash $dest -Algorithm $checksumType | ForEach-Object Hash).ToLower()
  Remove-Item $dest -Force -ErrorAction SilentlyContinue

  @{
    Version        = $chocoVersion
    Url32          = $url32
    Checksum32     = $checksum32
    ChecksumType32 = $checksumType
  }
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

Update-Package -ChecksumFor none -NoReadme
