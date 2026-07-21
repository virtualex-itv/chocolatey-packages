$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/126/WindowInspectorSetup-3.9.2.exe'
$checksum              = 'd6ed4a6b638a7e9255be26cdb234971222a99322b556a4d7ff66e334b2dc37b2'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName          = $env:ChocolateyPackageName
  unzipLocation        = $toolsDir
  fileType             = 'exe'
  softwareName         = 'WindowInspector*'
  url                  = $url
  checksum             = $checksum
  checksumType         = $checksumType
  silentArgs           = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes       = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
