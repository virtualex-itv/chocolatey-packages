$ErrorActionPreference = 'Stop';

$url64      = 'https://github.com/fosrl/windows/releases/download/0.7.1/pangolin-amd64-0.7.1.msi'
$checksum64 = '06a3cacff04d2859e3246d550ca85c8458c832bef75d2bf307fc38705980b471'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Pangolin*'
  silentArgs     = '/quiet'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
