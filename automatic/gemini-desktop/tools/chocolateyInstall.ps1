$ErrorActionPreference = 'Stop'

$url64      = 'https://dl.google.com/release2/Google%20DeepMind/acd3kexcaptgv6s7rlvqcodfttkq_1.16.0/GeminiSetup-1.16.0_uncompressed.exe'
$checksum64 = '02a3649952fcca275f310cc8ef9c5193a039f773f1310604ea657867d44a4289'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Gemini*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
