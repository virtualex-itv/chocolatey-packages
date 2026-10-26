$ErrorActionPreference = 'Stop'

$url      = 'https://github.com/LesFerch/WinSetView/releases/download/3.1.9/WinSetView-Setup.exe'
$checksum = 'b0658ab04145c6bcfc0b6291abfe7b3627cc97e856169b066bf3564d71072fce'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = $url
  checksum       = $checksum
  checksumType   = 'sha256'
  softwareName   = 'WinSetView*'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
