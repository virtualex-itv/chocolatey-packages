$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/harry0703/MangoDisk/releases/download/v2.1.1/MangoDisk-2.1.1-windows.exe'
$checksum64 = 'ef3bd07787d49056151b52b80e9fe94f8ff9c157ba61ac520e8ed637e690e53d'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'MangoDisk*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
