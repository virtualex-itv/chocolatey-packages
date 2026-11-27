$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/harry0703/MangoDisk/releases/download/v2.1.2/MangoDisk-2.1.2-windows.exe'
$checksum64 = 'c92245618d9c2caf95ec16119a09f875e5ab7984b244ce2762b38b89f76b08ff'

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
