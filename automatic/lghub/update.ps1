Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.logitechg.com/en-us/software/ghub'

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

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '\.exe'
  $Url32 = $download_page.Links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href

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

Update-Package -ChecksumFor none
