$ErrorActionPreference = 'Stop'

$url64         = 'https://github.com/amanthanvi/noctty/releases/download/v1.3.131/noctty-1.3.131-windows-x64-setup.exe'
$checksum64    = '175c7afbb13d47fe87b666d449e664b67248de32a593f2eda2d0fa010a96d03c'
$urlArm64      = 'https://github.com/amanthanvi/noctty/releases/download/v1.3.131/noctty-1.3.131-windows-arm64-setup.exe'
$checksumArm64 = 'e1590c39bca8df47f2b7fe52dcb0e1a005efa63fd6caba5f2ef60ec55e079d3c'

$isArm64 = $env:PROCESSOR_ARCHITECTURE -eq 'ARM64'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum64     = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType64 = 'sha256'
  softwareName   = 'noctty*'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
