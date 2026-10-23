$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/Splode/pomotroid/releases/download/v1.7.1/Pomotroid_1.7.1_x64-setup.exe'
$checksum64 = 'a64e2a8c5d292720355033e26525fa751f226a1c5660b946857fbf114ef25fa1'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Pomotroid*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
