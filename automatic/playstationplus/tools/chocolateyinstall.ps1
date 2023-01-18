$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download-psplus.playstation.com/downloads/psplus/pc/PlayStationPlus-12.2.0.exe'
$checksum              = 'D5E2589D5C9111387F965B315111D25516F89C2A812CD2A7E5AA2565C881DF2C'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName        = $env:ChocolateyPackageName
  unzipLocation      = $toolsDir
  fileType           = 'exe'
  softwareName       = "PlayStation Plus*"
  url                = $url
  checksum           = $checksum
  checksumType       = $checksumType
  silentArgs         = '/quiet'
  validExitCodes     = @(0, 3010, 1641)
}

# operating system check
$WindowsVersion=[Environment]::OSVersion.Version
if ($WindowsVersion.Major -ne "10") {
  throw "This package requires Windows 10 or Windows 11."
}

Install-ChocolateyPackage @packageArgs
