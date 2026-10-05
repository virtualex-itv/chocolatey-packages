Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases   = 'https://www.logitech.com/en-us/software/logi-options-plus'
$urlOffline = 'https://download01.logi.com/web/ftp/pub/techsupport/optionsplus/logioptionsplus_installer_offline.exe'

function Get-HeadInfo([string]$Url) {
  $request = [System.Net.WebRequest]::CreateDefault($Url)
  $request.Method = "HEAD"
  try {
    $response = $request.GetResponse()
    @{ ETag = $response.Headers.Get("ETag"); Length = $response.ContentLength.ToString() }
  } finally {
    if ($response) { $response.Dispose() }
  }
}

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

  # Get ETag and Content-Length of both installers via HEAD requests
  $online  = Get-HeadInfo $Url32
  $offline = Get-HeadInfo $urlOffline

  $saveFile = ".\info"
  $needsUpdate = $true

  if ((Test-Path $saveFile) -and !$global:au_Force) {
    $existingInfo = (Get-Content $saveFile -Encoding UTF8 -TotalCount 1) -split '\|'
    # Update if the ETag or Content-Length of either installer changed
    if ($existingInfo.Count -gt 4 -and
        $existingInfo[0] -eq $online.ETag  -and $existingInfo[2] -eq $online.Length -and
        $existingInfo[3] -eq $offline.ETag -and $existingInfo[4] -eq $offline.Length) {
      $needsUpdate = $false
      $result = @{ Url32 = $Url32; Version = $existingInfo[1] }
    }
  }

  if ($needsUpdate) {
    $result      = GetResultInformation $Url32
    $offlineInfo = GetResultInformation $urlOffline

    # Logitech can publish the offline installer hours after the online one; never pair different builds.
    if ($offlineInfo.Version -ne $result.Version) {
      Write-Host "Offline installer is $($offlineInfo.Version) but the online installer is $($result.Version); skipping until both match."
      return 'ignore'
    }

    $result.UrlOffline      = $urlOffline
    $result.ChecksumOffline = $offlineInfo.Checksum32
    "$($online.ETag)|$($result.Version)|$($online.Length)|$($offline.ETag)|$($offline.Length)" | Out-File $saveFile -Encoding utf8 -NoNewline
  }

  $result
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.Url32)'"
          "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
          "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
          "(^[$]urlOffline\s*=\s*)('.*')"      = "`$1'$($Latest.UrlOffline)'"
          "(^[$]checksumOffline\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumOffline)'"
      }
  }
}

Update-Package -ChecksumFor none
