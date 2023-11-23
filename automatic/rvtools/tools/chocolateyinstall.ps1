$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://robware.net/download/RVTools4.5.0.msi'
$checksum               = '6ad77c92371ad6fc210a8075879f65807e765ce99a30c236419fd705250ad018'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'msi'
  softwareName          = 'RVTools*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = "/qn REBOOT=ReallySuppress"
  validExitCodes        = @(0)
}

Install-ChocolateyPackage @packageArgs
