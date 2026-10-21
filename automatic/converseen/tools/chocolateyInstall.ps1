$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/Faster3ck/Converseen/releases/download/v0.15.2.9/Converseen-0.15.2.9-1-win64-setup.msi'
$checksum64 = 'c0fd5fd4a1d6279760c8d35416dca13708a74d7fa52d9028a51d0f8e912cac47'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Converseen*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
