$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.vmware.com/software/WKST-1702-WIN/VMware-workstation-full-17.0.2-21581411.exe'
$checksum               = 'ab925cf5b7424b8f28bf65a5c388ce6f680dfeb157612ee6d6c3dd0a63100a40'
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

$pp                     = Get-PackageParameters

if ( $pp.SERIALNUMBER ) { 
  $SN = $pp.SERIALNUMBER
  $packageArgs['silentArgs'] = '/s /v/qn EULAS_AGREED=1 SERIALNUMBER="' + $SN + '" AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 ADDLOCAL=ALL REBOOT=ReallySuppress'
}

Install-ChocolateyPackage @packageArgs
