$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/DISTRHO/Cardinal/releases/download/26.02/Cardinal-win64-26.02-installer.exe'
$checksum64 = '16f21250fe656fc766f6c1df79c45244bbdf55ffa90ff0c3c3ace9af70cf3e24'

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
