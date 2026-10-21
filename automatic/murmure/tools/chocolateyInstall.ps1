$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/Kieirra/murmure/releases/download/2.0.3/Murmure_x64.msi'
$checksum64 = '4c991d1992cdd52e15fee91d0d73e043ec19f0ec31b4c3c8067a9d4f321f32a5'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'murmure*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
