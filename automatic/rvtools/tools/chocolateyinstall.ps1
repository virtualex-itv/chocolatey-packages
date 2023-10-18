$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://robware.net/download/RVTools4.4.5.msi'
$checksum               = 'bd8155b63fb080d3da5146ccd19a386ccd72669bc8722af85693d5d4ad9c3e92'
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
