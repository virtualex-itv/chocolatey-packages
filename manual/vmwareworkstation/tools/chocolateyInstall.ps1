$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://softwareupdate.vmware.com/cds/vmw-desktop/ws/17.6.0/24238078/windows/core/VMware-workstation-17.6.0-24238078.exe.tar'
$checksum               = '8866101cd4d411dc4f75ecba2458b95ad5ca4edd177e2a500a9d3662ea37fc50'
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
  validExitCodes        = @(0, 3010, 1641)

}

$pp                     = Get-PackageParameters

if ( $pp.SERIALNUMBER ) {
  $SN = $pp.SERIALNUMBER
  $packageArgs['silentArgs'] = '/s /v/qn EULAS_AGREED=1 SERIALNUMBER="' + $SN + '" AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 REBOOT=ReallySuppress'
}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ErrorAction SilentlyContinue; if (Test-Path $_) { Set-Content "$_.ignore" } }
