$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download-psplus.playstation.com/downloads/psplus/pc/PlayStationPlus-12.8.0.exe'
$checksum              = '4D6B7F6DEECF837A69081148FB5D851177A5FAC3DBCAF6F771156AC75A685211'
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
