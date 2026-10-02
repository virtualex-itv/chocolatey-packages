$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://releases.warp.dev/stable/v0.2026.09.30.08.29.stable_01/WarpSetup.exe'
$checksum               = 'd7299334bc4ee6a2eb8cc38b3964d110bbb770707dd60aed6929084c5f473f33'
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
