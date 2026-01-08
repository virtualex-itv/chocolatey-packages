$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/114/TrayStatus-5.1.3-x64.zip'
$checksum              = '76e38d5352f8a56e529c80781d5377fe93f7d45478d2f8dca937340a580537c9'
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
