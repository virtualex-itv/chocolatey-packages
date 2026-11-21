$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/Tormak9970/Steam-Art-Manager/releases/download/v3.32.0/steam-art-manager.msi'
$checksum64 = 'b481c8505992dec27007cbe96ab1468e0a238fd596af1b6cfa89f1b7f6c8df53'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Steam Art Manager*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
