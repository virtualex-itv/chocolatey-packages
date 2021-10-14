$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.vmware.com/software/wkst/file/VMware-workstation-full-16.2.0-18760230.exe'
$checksum               = '39ce3a7e7731f9e260f2acb3a077b65967b0810332042ec169425ba5bc7dd21d'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  url                   = $url
  softwareName          = "VMware Workstation*"
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s /v/qn EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 ADDLOCAL=ALL REBOOT=ReallySuppress'
  validExitCodes        = @(0, 3010, 1614, 1641)
}

Install-ChocolateyPackage @packageArgs
