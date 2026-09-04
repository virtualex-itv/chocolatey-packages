$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://releases.warp.dev/stable/v0.2026.09.02.08.27.stable_01/WarpSetup.exe'
$checksum               = '718449814c54fbc7fec7d259450e09a2316ed4159c900b59c599a4757878d45e'
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
