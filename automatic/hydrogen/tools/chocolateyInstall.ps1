$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/hydrogen-music/hydrogen/releases/download/1.2.7/Hydrogen-1.2.7-win64.exe'
$checksum64 = 'ae3b9d31b5e65ddf127c7aabb56a6f39cc85cb714729a74ce65acfe97623220c'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Hydrogen*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
