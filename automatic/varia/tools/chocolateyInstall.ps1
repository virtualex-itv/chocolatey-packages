$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/giantpinkrobots/varia/releases/download/v2026.8.5-1/varia-windows-setup-amd64.exe'
$checksum64 = '3daaa666727156cd667abebb247e547fed15a1d6c8eb7b7395dd924ea240a2a3'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Varia*'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
