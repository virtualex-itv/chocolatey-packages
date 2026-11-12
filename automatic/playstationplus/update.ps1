Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://download-psplus.playstation.com/downloads/psplus/pc/latest'

function GetResultInformation([string]$Url32) {
  $fileName = Split-Path -Leaf $Url32
  $dest = "$env:TEMP\$fileName"

  Get-WebFile $Url32 $dest | Out-Null

  $version         = (Get-Command $dest).FileVersionInfo.ProductVersion
  $ChecksumType    = 'sha256'
  $checksum32      = Get-FileHash $dest -Algorithm $checksumType | ForEach-Object Hash

  Remove-Item $dest -Force -ErrorAction SilentlyContinue

  @{
    Url32             = $Url32
    Version           = $version
    ChecksumType32    = $ChecksumType
    Checksum32        = $checksum32
  }
}

# HEAD without throwing on 4xx/5xx; optionally without following a redirect (works in Windows PowerShell 5.1 and 7)
function Get-HeadResult([string]$Url, [bool]$FollowRedirects = $true) {
  $request = [System.Net.HttpWebRequest]::Create($Url)
  $request.Method = 'HEAD'
  $request.AllowAutoRedirect = $FollowRedirects
  try { $response = $request.GetResponse() }
  catch [System.Net.WebException] { $response = $_.Exception.Response; if (-not $response) { throw } }
  try { @{ Status = [int]$response.StatusCode; Location = $response.Headers['Location'] } } finally { $response.Dispose() }
}

function Test-InstallerExists([string]$Url) { (Get-HeadResult $Url).Status -eq 200 }

# Read the vendor's 'latest' redirect WITHOUT following it: Get-RedirectedUrl throws when the target is gone (Nov 2026: 12.7.0 was deleted)
function Get-LatestRedirect([string]$Url) {
  $head = Get-HeadResult $Url $false
  if ($head.Status -notin 301, 302, 303, 307, 308 -or -not $head.Location) { throw "Expected a redirect from '$Url', got HTTP $($head.Status)" }
  ([uri]::new([uri]$Url, $head.Location)).AbsoluteUri
}

# The vendor keeps only the newest installer and its 'latest' redirect can lag (it still pointed at the deleted 12.7.0 while 12.8.0 was live),
# so also probe the versions after the redirect's and use the highest installer that exists.
function Find-NewestInstaller([string]$Url) {
  if ($Url -notmatch '^(?<base>.*/PlayStationPlus-)(?<ver>\d+\.\d+\.\d+)\.exe$') { return $Url }
  $base = $Matches['base']
  $v = [version]$Matches['ver']
  # later patches of this minor, patches 0-3 of the next three minors, then the next major
  $candidates = @()
  1..3 | ForEach-Object { $candidates += [version]::new($v.Major, $v.Minor, $v.Build + $_) }
  1..3 | ForEach-Object { $minor = $v.Minor + $_; 0..3 | ForEach-Object { $candidates += [version]::new($v.Major, $minor, $_) } }
  $candidates += [version]::new($v.Major + 1, 0, 0)
  $found = $candidates | Sort-Object -Descending | Where-Object { Test-InstallerExists "$base$_.exe" } | Select-Object -First 1
  if ($found) { Write-Warning "The 'latest' redirect points at $v but $found exists; using $found."; return "$base$found.exe" }
  $Url
}

function global:au_GetLatest {
  $Url32 = Get-LatestRedirect $releases
  if ($Url32 -notmatch '^https://download-psplus\.playstation\.com/.+\.exe$') { throw "Unexpected PlayStation Plus download URL: '$Url32'" }
  $Url32 = Find-NewestInstaller $Url32
  if (-not (Test-InstallerExists $Url32)) { throw "PlayStation Plus installer not found: '$Url32'" }

  # Get ETag and Content-Length via HEAD request
  $request = [System.Net.WebRequest]::CreateDefault($Url32)
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
      $result = @{ Url32 = $Url32; Version = $existingInfo[1] }
    }
  }

  if ($needsUpdate) {
    $result = GetResultInformation $Url32
    "$etag|$($result.Version)|$contentLength" | Out-File $saveFile -Encoding utf8 -NoNewline
  }

  $result
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
