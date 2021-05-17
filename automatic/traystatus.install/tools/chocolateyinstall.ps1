$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/114/TrayStatusSetup-4.5.exe'
$checksum              = '22620cdac1077822a8ed0dbb532d862aa6426e22744d4aa844edf3bacf14009f'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName          = $env:ChocolateyPackageName
  unzipLocation        = $toolsDir
  fileType             = 'exe'
  softwareName         = 'TrayStatus*'
  url                  = $url
  checksum             = $checksum
  checksumType         = $checksumType
  silentArgs           = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes       = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
