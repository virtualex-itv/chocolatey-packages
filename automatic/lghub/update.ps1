Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$releases     = 'https://www.logitechg.com/en-us/software/ghub'
$releaseNotes = 'https://marketplace.logi.com/releasenotes/ghub/en'

function GetChecksum([string]$Url32) {
  $fileName = Split-Path -Leaf $Url32
  $dest = "$env:TEMP\$fileName"

  Get-WebFile $Url32 $dest | Out-Null
  $checksum32 = Get-FileHash $dest -Algorithm sha256 | ForEach-Object Hash
  Remove-Item $dest -Force -ErrorAction SilentlyContinue

  @{
    Url32          = $Url32
    ChecksumType32 = 'sha256'
    Checksum32     = $checksum32
  }
}

function global:au_GetLatest {
  # Version comes from Logitech's release notes, newest entry first. Do NOT read the
  # installer's ProductVersion - it is a bootstrapper whose own version lags the app.
  $notes   = Get-RetryWebContent $releaseNotes -MustMatch '20\d\d\.\d+\.\d+'
  $version = ([regex]::Match($notes, '20\d\d\.\d+\.\d+')).Value
  if (-not $version) { throw "Could not find a G HUB version on $releaseNotes" }

  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $Url32 = $download_page.Links | Where-Object { $_.href -match '\.exe' } | Select-Object -First 1 -ExpandProperty href
  if (-not $Url32) { throw "Could not find an installer link on $releases" }

  $nuspecVersion = ([xml](Get-Content "$PSScriptRoot\lghub.nuspec")).package.metadata.version

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

  # Re-hash when the CDN swaps the stub OR the nuspec is behind, so a version bump
  # never reaches au_SearchReplace without a matching checksum.
  if ((Test-Path $saveFile) -and !$global:au_Force) {
    $existingInfo = (Get-Content $saveFile -Encoding UTF8 -TotalCount 1) -split '\|'
    if ($existingInfo[0] -eq $etag -and $existingInfo.Count -gt 2 -and $existingInfo[2] -eq $contentLength -and $nuspecVersion -eq $version) {
      $needsUpdate = $false
      $result = @{ Url32 = $Url32; Version = $version }
    }
  }

  if ($needsUpdate) {
    $result = GetChecksum $Url32
    $result.Version = $version
    "$etag|$version|$contentLength" | Out-File $saveFile -Encoding utf8 -NoNewline
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

Update-Package -ChecksumFor none
