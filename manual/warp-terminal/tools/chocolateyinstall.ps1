$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://releases.warp.dev/stable/v0.2025.11.05.08.12.stable_00/WarpSetup.exe'
$checksum               = '139ad9607735b4b82ccf088a5fe878afb940ef8cbec2c4ee757c054d70f73c6f'
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
