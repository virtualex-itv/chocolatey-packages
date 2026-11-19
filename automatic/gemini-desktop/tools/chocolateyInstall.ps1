$ErrorActionPreference = 'Stop'

$url64      = 'https://dl.google.com/release2/Google%20DeepMind/jrago3sbw7xgrkpxfotop5dwxu_1.21.1/GeminiSetup-1.21.1_uncompressed.exe'
$checksum64 = 'a4d3252061de61d968e7ea4503b20dc37e1966ce2434b9243e05b4c92710bba9'

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
