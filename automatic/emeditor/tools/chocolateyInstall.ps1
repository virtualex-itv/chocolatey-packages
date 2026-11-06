$ErrorActionPreference = 'Stop'

$url64      = 'https://download.emeditor.com/emed64_26.4.1.msi'
$checksum64 = 'a24ae76cb702c8311ca0458d7a330ba4fcbddb49aa151d0e45ff800c018d0654'

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
