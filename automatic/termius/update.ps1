Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.termius.com/windows'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $url32 = Get-RedirectedUrl ($download_page.Links | Where-Object {$_.href -like "*/win"} | Select-Object -First 1 -ExpandProperty href)

  $fileName = Split-Path -Leaf $Url32
  $dest = "$env:TEMP\$fileName"

  Get-WebFile $Url32 $dest | Out-Null

  $version = (Get-Item $dest).VersionInfo.FileVersion
  $ChecksumType = 'sha256'
  $checksum32 = Get-FileHash $dest -Algorithm $checksumType | ForEach-Object Hash

  Remove-Item $dest -Force -ErrorAction SilentlyContinue

  @{
    Url32            = $Url32
    Version          = $version
    ChecksumType32   = $ChecksumType
    Checksum32       = $checksum32
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
