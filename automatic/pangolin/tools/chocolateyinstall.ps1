$ErrorActionPreference = 'Stop';

$url64      = 'https://github.com/fosrl/windows/releases/download/0.10.4/pangolin-amd64-0.10.4.msi'
$checksum64 = '987b52e21fd79e9845323a209a4c0a8ba504dfed231fbef1e08438e5a5754dfb'

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
