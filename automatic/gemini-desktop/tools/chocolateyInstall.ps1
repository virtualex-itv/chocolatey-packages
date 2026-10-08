$ErrorActionPreference = 'Stop'

$url64      = 'https://dl.google.com/release2/Google%20DeepMind/aduwcapstkzvhnjcpawakc5hjfkq_1.14.0/GeminiSetup-1.14.0_uncompressed.exe'
$checksum64 = 'e45e3a4ab51fbd9fa8095f38bb124db298f138eb20128e42e87271e145e8b14b'

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
