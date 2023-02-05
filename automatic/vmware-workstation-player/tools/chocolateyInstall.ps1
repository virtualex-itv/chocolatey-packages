$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.vmware.com/software/WKST-PLAYER-1701/VMware-player-full-17.0.1-21139696.exe'
$checksum               = '270d500f151fba0fb159cd48bb53cb962971a2246c484b1bacf06152e41b32db'
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
