Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

function global:au_GetLatest {
  # Query winget-pkgs for available Warp versions
  $apiUrl = 'https://api.github.com/repos/microsoft/winget-pkgs/contents/manifests/w/Warp/Warp'
  $response = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing

  # Get all version directories and sort by date embedded in version string
  # Format: v0.YYYY.MM.DD.HH.MM.stable_XX
  $versions = $response | Where-Object { $_.type -eq 'dir' -and $_.name -match '^v0\.\d{4}\.\d{2}\.\d{2}' } | ForEach-Object {
    $v = $_.name
    if ($v -match '^v0\.(\d{4})\.(\d{2})\.(\d{2})\.(\d{2})\.(\d{2})\.stable_(\d+)$') {
      [PSCustomObject]@{
        FullVersion  = $v
        SortKey      = "{0}{1}{2}{3}{4}{5:D2}" -f $Matches[1], $Matches[2], $Matches[3], $Matches[4], $Matches[5], [int]$Matches[6]
        Year         = $Matches[1]
        Month        = $Matches[2]
        Day          = $Matches[3]
        Hour         = $Matches[4]
        Minute       = $Matches[5]
        StableBuild  = $Matches[6]
      }
    }
  } | Sort-Object -Property SortKey -Descending

  $latest = $versions | Select-Object -First 1
  $fullVersion = $latest.FullVersion

  # Chocolatey package version format: YYYY.M.D.HHMMBB
  # 4th octet combines time (HHMM) + stable build number (BB)
  # e.g., v0.2026.01.14.08.15.stable_04 -> 2026.1.14.081504
  $fourthOctet = "{0}{1}{2:D2}" -f $latest.Hour, $latest.Minute, [int]$latest.StableBuild
  $chocoVersion = "{0}.{1}.{2}.{3}" -f $latest.Year, [int]$latest.Month, [int]$latest.Day, $fourthOctet

  # Build download URL
  $url32 = "https://releases.warp.dev/stable/$fullVersion/WarpSetup.exe"

  # Download and calculate checksum
  $fileName = "WarpSetup_$fullVersion.exe"
  $dest = "$env:TEMP\$fileName"

  Get-WebFile $url32 $dest | Out-Null

  $checksumType = 'sha256'
  $checksum32 = (Get-FileHash $dest -Algorithm $checksumType | ForEach-Object Hash).ToLower()

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
