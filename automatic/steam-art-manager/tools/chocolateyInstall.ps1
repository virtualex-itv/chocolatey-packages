$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/Tormak9970/Steam-Art-Manager/releases/download/v3.31.0/steam-art-manager.msi'
$checksum64 = '13d25d73fdcfaeeebdff103fc752f7e347673b6dadcb1a8c77d829402a6500d7'

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
