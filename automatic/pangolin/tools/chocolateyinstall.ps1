$ErrorActionPreference = 'Stop';

$url64      = 'https://github.com/fosrl/windows-linux/releases/download/windows-0.16.0/pangolin-amd64-0.16.0.msi'
$checksum64 = '224e4f3021ca6dd5b34e59330928ad64835a347285157483e5857c5afd09f643'

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
