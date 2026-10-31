$ErrorActionPreference = 'Stop'

$url64      = 'https://dl.google.com/release2/Google%20DeepMind/ckw2kln3ffw6im6sumtnqnfp7e_1.17.0/GeminiSetup-1.17.0_uncompressed.exe'
$checksum64 = 'e944617716403ec523e9b87d06400ba47fc2d24e5619a635177de3640ec49b6d'

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
