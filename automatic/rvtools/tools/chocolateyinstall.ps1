$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://robware.net/download/c2f0942d59a42901b18e06ea73a4dc4be8e57670c8973429c5ba5da99f60580412/RVTools4.4.2.msi'
$checksum               = '19cdc83c7eac3e6697792b2a4ebef3e3d0dd15053dfdc82ed5fb1b68197f1000'
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
