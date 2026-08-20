$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://releases.warp.dev/stable/v0.2026.08.19.08.15.stable_01/WarpSetup.exe'
$checksum               = 'ea4f095ab9954a1faf35b12dfb5721a881bfa31d764a264498204d884fca3be2'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = 'Warp*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/ALLUSERS=0 /VERYSILENT /NORESTART /SUPPRESSMSGBOXES'
  validExitCodes        = @(0, 3010, 1605, 1614, 1641)
}

Install-ChocolateyPackage @packageArgs
