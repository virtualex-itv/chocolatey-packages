$ErrorActionPreference = 'Stop'

$url64      = 'https://dl.google.com/release2/Google%20DeepMind/addznku7or7dm5tq34obrljjxjxq_1.13.1/GeminiSetup-1.13.1_uncompressed.exe'
$checksum64 = 'e660bfd7bf1bfffce65d8227bf8dc8caed34317110ec5139ae3ace5bcb5aaa94'

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
