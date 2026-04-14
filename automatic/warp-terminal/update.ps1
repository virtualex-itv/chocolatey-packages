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
  $headers = @{ 'User-Agent' = 'AU-Updater' }
  if ($env:github_api_key) { $headers.Authorization = "Bearer $env:github_api_key" }

  $candidates = [System.Collections.Generic.List[object]]::new()

  # Primary: merged versions from winget-pkgs directory listing
  $response = Invoke-RestMethod -Uri 'https://api.github.com/repos/microsoft/winget-pkgs/contents/manifests/w/Warp/Warp' -Headers $headers -UseBasicParsing
  $response | Where-Object { $_.type -eq 'dir' } | ForEach-Object {
    $parsed = ParseWarpVersion $_.name
    if ($parsed) { $candidates.Add($parsed) }
  }

  # Fallback: open PRs catch versions submitted to winget-pkgs but not yet merged.
  # Warp's CI auto-submits PRs immediately on release, so this closes the lag window.
  try {
    $prs = Invoke-RestMethod -Uri 'https://api.github.com/search/issues?q=repo:microsoft/winget-pkgs+Warp.Warp+is:pr+is:open&sort=created&order=desc&per_page=10' -Headers $headers
    $prs.items | ForEach-Object {
      if ($_.title -match 'Warp\.Warp version (v0\.\d+\.\d+\.\d+\.\d+\.\d+\.stable_\d+)') {
        $parsed = ParseWarpVersion $Matches[1]
        if ($parsed) { $candidates.Add($parsed) }
      }
    }
  } catch {
    Write-Warning "Open PR check failed (rate limit or network issue): $_"
  }

  $latest = $candidates | Sort-Object SortKey -Descending | Select-Object -First 1
  if (-not $latest) { throw 'No Warp versions found from winget-pkgs or open PRs' }

  $source = if ($candidates | Where-Object { $_.SortKey -eq $latest.SortKey -and $_.FullVersion -eq $latest.FullVersion } | Select-Object -First 1) { 'merged' } else { 'open PR' }
  Write-Host "Latest Warp version: $($latest.FullVersion) (source: winget-pkgs)"

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

Update-Package -ChecksumFor none
