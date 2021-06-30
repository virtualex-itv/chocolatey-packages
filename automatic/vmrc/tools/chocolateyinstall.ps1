$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://softwareupdate.vmware.com/cds/vmw-desktop/vmrc/12.0.1/18113358/windows/vmrc-windows.tar'
$checksum               = 'fdc73e24381ab2c45f24d29932eaa4157bb2ef3f97ce8e007cada856c2560fe2'
$checksumType           = 'sha256'

$zippackageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType

}

Install-ChocolateyZipPackage @zippackageArgs

$fileLocation = Get-ChildItem $toolsDir\VMware-VMRC*.exe

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  file                  = $fileLocation
  softwareName          = 'VMware Remote Console*'
  silentArgs            = '/s /v /qn EULAS_AGREED=1 AUTOSOFTWAREUPDATE=1 DATACOLLECTION=0 REBOOT=ReallySuppress'
  validExitCodes        = @(0, 3010, 1641)

}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ErrorAction SilentlyContinue; if (Test-Path $_) { Set-Content "$_.ignore" } }
