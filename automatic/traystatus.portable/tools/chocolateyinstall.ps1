$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/114/TrayStatus-5.2.1-x64.zip'
$checksum              = '1d994f757f82f3fd7058167c516815e50f11d62f48396e1dee38c27b31751bb0'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName          = $env:ChocolateyPackageName
  unzipLocation        = $toolsDir
  fileType             = 'exe'
  softwareName         = 'TrayStatus*'
  url                  = $url
  checksum             = $checksum
  checksumType         = $checksumType
  silentArgs           = "/qn /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log`""
  validExitCodes       = @(0, 3010, 1641)
}

Install-ChocolateyZipPackage @packageArgs
