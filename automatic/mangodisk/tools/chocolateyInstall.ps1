$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/harry0703/MangoDisk/releases/download/v1.2.3/MangoDisk-1.2.3-windows.exe'
$checksum64 = 'b1f5c78aac2370895179b55779cc18da1d052081cc2ba7c8fbe7288e9b35d5b8'

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
