Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.binaryfortress.com/NotepadReplacer/Download/'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '*/?Package*'
  $Url32 = Get-RedirectedUrl ($download_page.Links | Where-Object { $_.href -like $re } | Select-Object -First 1 -ExpandProperty href)

  # Extract version from URL like NotepadReplacerSetup-1.6c.exe
  # Handles versions like 1.6, 1.6c, 1.10, 1.10a, etc.
  if ($Url32 -match 'Setup-(\d+\.\d+)([a-z]?)\.exe$') {
    $version = $matches[1]
    # Convert letter suffix to patch number (a=1, b=2, c=3, etc.) or 0 if no suffix
    $suffix = $matches[2]
    if ($suffix) {
      $patch = [int][char]$suffix - [int][char]'a' + 1
    } else {
      $patch = 0
    }
    $version = "$version.$patch"
  } else {
    throw "Could not extract version from URL: $Url32"
  }
  $ChecksumType = 'sha256'

  @{
    Url32             = $Url32
    Version           = $version
    ChecksumType32    = $ChecksumType
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
