$ErrorActionPreference = 'Stop';

$url64      = 'https://github.com/fosrl/windows/releases/download/0.10.1/pangolin-amd64-0.10.1.msi'
$checksum64 = '29672d4a41255e896f7644050c1b913a1b4c77ed3b72c172208395f900ceec43'

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
