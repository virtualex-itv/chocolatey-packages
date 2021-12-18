$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/126/WindowInspectorSetup-2.8.exe'
$checksum              = 'b87d38e27b7d06b54ecf5d854a7f86ea129e0810ee830b9ed74d1f0ea7c8a8ae'
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
