$ErrorActionPreference = 'Stop'

$url      = 'https://github.com/LesFerch/WinSetView/releases/download/3.2.0/WinSetView-Setup.exe'
$checksum = '83633cbe6ba332118ef15a918a2a2652c555971157cef20f6b8de8a10e9f738c'

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
