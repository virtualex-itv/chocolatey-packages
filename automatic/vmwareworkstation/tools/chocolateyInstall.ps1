$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://softwareupdate.vmware.com/cds/vmw-desktop/ws/17.6.3/24583834/windows/core/VMware-workstation-17.6.3-24583834.exe.tar'
$checksum               = '2e87994dd2580bc006a0b96ef089f500a718d05c3302d78bd9c85df4439cf67c'
$checksumType           = 'sha256'

$zippackageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType

}

Install-ChocolateyZipPackage @zippackageArgs

$fileLocation = Get-ChildItem $toolsDir\VMware-workstation*.exe

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  file                  = $fileLocation
  softwareName          = 'VMware Workstation*'
  silentArgs            = '/s /v /qn EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 REBOOT=ReallySuppress'
  validExitCodes        = @(0, 3010, 1614, 1641)

}

$pp                     = Get-PackageParameters

if ( $pp.SERIALNUMBER ) {
  $SN = $pp.SERIALNUMBER
  $packageArgs['silentArgs'] = '/s /v/qn EULAS_AGREED=1 SERIALNUMBER="' + $SN + '" AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 REBOOT=ReallySuppress'
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ErrorAction SilentlyContinue; if (Test-Path $_) { Set-Content "$_.ignore" } }
