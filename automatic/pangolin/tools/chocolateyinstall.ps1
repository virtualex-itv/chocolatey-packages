$ErrorActionPreference = 'Stop';

$url64      = 'https://github.com/fosrl/windows-linux/releases/download/windows-0.17.0/pangolin-amd64-0.17.0.msi'
$checksum64 = 'a63c8afc8ec8b437b564ced65a894a1bb69f1f95430dfcc07ce432bd516552ed'

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
