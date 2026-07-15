Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

# Always-latest installer URL. Version detection reads the downloaded exe's version
# metadata, guarded by an ETag + Content-Length HEAD check so the ~128MB download only
# happens when Garmin actually replaces the binary (same pattern as logioptionsplus).
# The old source - scraping "Current Version of Garmin Express for Windows: X.Y.Z" from
# the support FAQ page - died in July 2026 when Garmin moved support.garmin.com to a
# JS-rendered SPA whose HTML no longer contains the version text.
$url32 = 'https://download.garmin.com/omt/express/GarminExpress.exe'

function GetResultInformation([string]$Url32) {
  $fileName = Split-Path -Leaf $Url32
  $dest = "$env:TEMP\$fileName"

  Get-WebFile $Url32 $dest | Out-Null

  $rawVersion = (Get-Command $dest).FileVersionInfo.ProductVersion
  if (-not $rawVersion) { $rawVersion = (Get-Command $dest).FileVersionInfo.FileVersion }
  if (-not $rawVersion) { throw "Could not read a version from $fileName" }

  # Normalize to 3 segments (7.29.0.0 -> 7.29.0) to match the package's existing
  # version scheme; pad to at least X.Y.0.
  $parts = ($rawVersion.Trim() -split '\.')
  while ($parts.Count -lt 3) { $parts += '0' }
  $version = ($parts | Select-Object -First 3) -join '.'

  $ChecksumType = 'sha256'
  $checksum32   = Get-FileHash $dest -Algorithm $checksumType | ForEach-Object Hash

  Remove-Item $dest -Force -ErrorAction SilentlyContinue

  @{
    URL32          = $Url32
    Version        = $version
    ChecksumType32 = $ChecksumType
    Checksum32     = $checksum32
  }
}

function global:au_GetLatest {
  # Get ETag and Content-Length via HEAD request
  $request = [System.Net.WebRequest]::CreateDefault($url32)
  $request.Method = "HEAD"
  try {
    $response = $request.GetResponse()
    $etag = $response.Headers.Get("ETag")
    $contentLength = $response.ContentLength.ToString()
  } finally {
    if ($response) { $response.Dispose() }
  }

  $saveFile = ".\info"
  $needsUpdate = $true

  if ((Test-Path $saveFile) -and !$global:au_Force) {
    $existingInfo = (Get-Content $saveFile -Encoding UTF8 -TotalCount 1) -split '\|'
    # Update if either ETag or Content-Length changed
    if ($existingInfo[0] -eq $etag -and $existingInfo.Count -gt 2 -and $existingInfo[2] -eq $contentLength) {
      $needsUpdate = $false
      $result = @{ URL32 = $url32; Version = $existingInfo[1] }
    }
  }

  if ($needsUpdate) {
    $result = GetResultInformation $url32
    "$etag|$($result.Version)|$contentLength" | Out-File $saveFile -Encoding utf8 -NoNewline
  }

  $result
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
    }
  }
}

Update-Package -ChecksumFor none
