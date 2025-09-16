$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://releases.warp.dev/stable/v0.2025.09.03.08.11.stable_02/WarpSetup.exe'
$checksum               = '2ed9b634138db8075dd4535efa60cc832983f6d81acd23f5ba6321456c6bf0fb'
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
