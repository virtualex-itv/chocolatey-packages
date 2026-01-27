$ErrorActionPreference = 'Stop';

$url64      = 'https://github.com/fosrl/windows/releases/download/0.5.0/pangolin-amd64-0.5.0.msi'
$checksum64 = '67f1a1e9557effdb56f504e7402efd597caa7e7700c63e2fe60374e3a3294b20'

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
