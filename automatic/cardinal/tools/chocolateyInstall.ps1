$ErrorActionPreference = 'Stop'

$url64      = ''
$checksum64 = ''

$pp = Get-PackageParameters
$silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
# The vendor's default selection has no standalone app; /Standalone adds the native one.
if ($pp['Standalone']) { $silentArgs += ' /COMPONENTS="resources,carla,native,lv2,vst2,vst3,clap"' }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Cardinal*'
  silentArgs     = $silentArgs
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
