Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.binaryfortress.com/WindowInspector/Download/'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = 'Log='
  $url = $download_page.Links | Where-Object { $_.href -match $re } | Select-Object -Skip 1 -First 1 -ExpandProperty href
  $url32 = Get-RedirectedUrl $url

  # Extract version from URL like WindowInspector-3.9.1-x64.zip or WindowInspector-3.8c-x64.zip
  if ($url32 -match 'WindowInspector-(\d+\.\d+\.\d+)(?:-x64)?\.zip$') {
    $version = $matches[1]
  } elseif ($url32 -match 'WindowInspector-(\d+\.\d+)([a-z]?)(?:-x64)?\.zip$') {
    $version = $matches[1]
    $suffix = $matches[2]
    if ($suffix) {
      $patch = [int][char]$suffix - [int][char]'a' + 1
    } else {
      $patch = 0
    }
    $version = "$version.$patch"
  } else {
    throw "Could not extract version from URL: $url32"
  }
  $ChecksumType = 'sha256'

  @{
    Url32            = $Url32
    Version          = $version
    ChecksumType32   = $ChecksumType
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
