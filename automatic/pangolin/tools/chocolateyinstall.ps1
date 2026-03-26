$ErrorActionPreference = 'Stop';

$url64      = 'https://github.com/fosrl/windows/releases/download/0.8.1/pangolin-amd64-0.8.1.msi'
$checksum64 = 'af5cb19f3df76d70094f12042f1221622f6d121f44094c70ab09f082a98b9b43'

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
