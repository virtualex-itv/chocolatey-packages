$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download-psplus.playstation.com/downloads/psplus/pc/PlayStationPlus-12.6.0.exe'
$checksum              = 'BFF099C942B16AEEFA0A18146D06A9B32BC77FC5F9BA9119994906D78BAE0FD9'
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
