$ErrorActionPreference = 'Stop'

$url64      = 'https://dl.google.com/release2/Google%20DeepMind/aowpaaarspyketq2o5kyrioqxu_1.19.0/GeminiSetup-1.19.0_uncompressed.exe'
$checksum64 = '48cbd56de58188db534dc280f8805f09ae4047037e431c1d6b20483be50ce179'

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
