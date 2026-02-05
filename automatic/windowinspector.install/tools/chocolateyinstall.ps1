$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/126/WindowInspectorSetup-3.9.exe'
$checksum              = '3b0a6d48b2cbf830a38eb4fce131c05a2222b3dafebd2a9f786166cde45ff718'
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
