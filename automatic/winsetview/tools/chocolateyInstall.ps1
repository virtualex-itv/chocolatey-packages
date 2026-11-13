$ErrorActionPreference = 'Stop'

$url      = 'https://github.com/LesFerch/WinSetView/releases/download/3.2.1/WinSetView-Setup.exe'
$checksum = '5f6499102ec46100d6460e402aee117c79860c453c5458985e0122f70a184dfb'

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
