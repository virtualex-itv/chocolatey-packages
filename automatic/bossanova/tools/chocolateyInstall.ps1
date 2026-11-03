$ErrorActionPreference = 'Stop'

$url64      = ''
$checksum64 = ''

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Bossanova*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Write-Warning 'Bossanova needs a TINYGEM account (the free tier works) and checks its license online from time to time.'

Install-ChocolateyPackage @packageArgs
