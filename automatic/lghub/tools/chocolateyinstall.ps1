$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe'
$checksum              = '905115AC915E245BA71BB678B7B145648C296379A10FC8DA95E8E84AEC830832'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName        = $env:ChocolateyPackageName
  unzipLocation      = $toolsDir
  fileType           = 'exe'
  softwareName       = "Logitech G HUB*"
  url                = $url
  checksum           = $checksum
  checksumType       = $checksumType
  silentArgs         = '--silent'
  validExitCodes     = @(0, 3010, 1641)
}

# operating system check
$WindowsVersion=[Environment]::OSVersion.Version
if ($WindowsVersion.Major -ne "10") {
  throw "This package requires Windows 10 or Windows 11."
}

Install-ChocolateyPackage @packageArgs
