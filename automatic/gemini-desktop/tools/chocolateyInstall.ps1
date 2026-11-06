$ErrorActionPreference = 'Stop'

$url64      = 'https://dl.google.com/release2/Google%20DeepMind/mu4o5z2at26ymd2qhpxppwy2ju_1.18.0/GeminiSetup-1.18.0_uncompressed.exe'
$checksum64 = '61b10b307de9d33b700178fc2ea010eda447c7cbc83ba8b648d7639642559878'

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
