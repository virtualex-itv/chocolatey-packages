$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/giantpinkrobots/varia/releases/download/v2026.11.16/varia-windows-setup-amd64.exe'
$checksum64 = '663eaa443e087bbbbed8c97386e620de5d15cc98b79e50801e8a3d62322bde41'

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
