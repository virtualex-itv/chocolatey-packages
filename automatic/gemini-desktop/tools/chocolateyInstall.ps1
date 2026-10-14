$ErrorActionPreference = 'Stop'

$url64      = 'https://dl.google.com/release2/Google%20DeepMind/acv5qauetud6hcvw6zsqz2us3cfq_1.15.0/GeminiSetup-1.15.0_uncompressed.exe'
$checksum64 = '68e94affff42e96c2a690ae3f521a42afcd4bb5a481ae0d6a59a71c02d8df52e'

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
