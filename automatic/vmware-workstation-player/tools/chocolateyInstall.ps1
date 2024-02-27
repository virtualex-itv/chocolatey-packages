$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.vmware.com/software/WKST-PLAYER-1751/VMware-player-full-17.5.1-23298084.exe'
$checksum               = '31036d3e5c107b8665f9e82e2ea0761f8ebf902e4dfea9e1db0e3295532c30e6'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  url                   = $url
  softwareName          = "VMware Player*"
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s /v/qn EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 ADDLOCAL=ALL REBOOT=ReallySuppress'
  validExitCodes        = @(0, 3010, 1614, 1641)
}

Install-ChocolateyPackage @packageArgs
