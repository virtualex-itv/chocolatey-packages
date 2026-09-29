$ErrorActionPreference = 'Stop'

$url64      = 'https://dl.google.com/release2/Google%20DeepMind/acu2nhwybvnumbmdlv6g34zpz67q_1.12.3/GeminiSetup-1.12.3_uncompressed.exe'
$checksum64 = '60f6d4a72c4063bb663254bbaac5239434d4c7bfe172e168304f2b8d823e7f53'

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
