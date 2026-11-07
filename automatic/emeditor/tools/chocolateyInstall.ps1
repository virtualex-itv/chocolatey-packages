$ErrorActionPreference = 'Stop'

$url64      = 'https://download.emeditor.com/emed64_26.4.2.msi'
$checksum64 = '8746d25aa5ea3ea63df47385d13986146e8f3021c279cc13bdb3678604c1de34'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'EmEditor*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
