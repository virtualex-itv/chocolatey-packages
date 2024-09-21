$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://softwareupdate.vmware.com/cds/vmw-desktop/ws/12.5.9/7535481/windows/core/VMware-workstation-12.5.9-7535481.exe.tar'
$checksum               = 'f294b76b3993c7bc74379992f09bfc7991040744c2c8290940477aa89c23e9e6'
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
