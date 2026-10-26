$ErrorActionPreference = 'Stop'

$url64      = 'https://download.emeditor.com/emed64_26.4.0.msi'
$checksum64 = 'f6ce1ec8ce60d2f66ffa9f57735e143dbe0a2e9f702270ee3f6c1dba2650fbbd'

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
