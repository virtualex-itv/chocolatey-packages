$ErrorActionPreference = 'Stop'

$url32      = 'https://github.com/pavlobu/deskreen/releases/download/v3.2.16/deskreen-ce-3.2.16-ia32.msi'
$checksum32 = 'dd6cde647757bd9b86d3d73077ffd3b736d8c0e60e091a6b08b4cf52d123bceb'
$url64      = 'https://github.com/pavlobu/deskreen/releases/download/v3.2.16/deskreen-ce-3.2.16-x64.msi'
$checksum64 = '9c890626f9a7db5590b9885f862f83f6a8c1526d97ad860e146e8cf7b52ddea6'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Deskreen CE*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
