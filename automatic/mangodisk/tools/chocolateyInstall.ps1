$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/harry0703/MangoDisk/releases/download/v1.2.1/MangoDisk-1.2.1-windows.exe'
$checksum64 = 'd52a8c895d417426e35e7059ed55efbe5d4637b43b68c08c9682a28654897efb'

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
