$ErrorActionPreference = 'Stop'

$url64      = 'https://bsnv.app/releases/windows-x64/0.1.54/Bossanova-Setup.exe'
$checksum64 = '2391a4e94abeb66cc355b2e8c9d6f3a9f2046cd29580d9fb07ba3bce2d25c3fb'

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
