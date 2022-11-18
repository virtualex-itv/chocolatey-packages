$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.vmware.com/software/WKST-PLAYER-1700/VMware-player-full-17.0.0-20800274.exe'
$checksum               = 'ae238c457a100f15a6d009bfeee4ff277dce181e96a279d486f07f30da433183'
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
