$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://softwareupdate.vmware.com/cds/vmw-desktop/player/17.6.2/24409262/windows/core/VMware-player-17.6.2-24409262.exe.tar'
$checksum               = '5b87ea0bcd3628b528894b3211790441be45ec17443aea30c161c41b438da3e8'
$checksumType           = 'sha256'

$zippackageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType

}

Install-ChocolateyZipPackage @zippackageArgs

$fileLocation = Get-ChildItem $toolsDir\VMware-player*.exe

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  file                  = $fileLocation
  softwareName          = 'VMware Player*'
  silentArgs            = '/s /v /qn EULAS_AGREED=1 AUTOSOFTWAREUPDATE=0 DATACOLLECTION=0 REBOOT=ReallySuppress'
  validExitCodes        = @(0, 3010, 1614, 1641)

}

Install-ChocolateyInstallPackage @packageArgs

Get-ChildItem $toolsDir\*.exe | ForEach-Object { Remove-Item $_ -ErrorAction SilentlyContinue; if (Test-Path $_) { Set-Content "$_.ignore" } }
