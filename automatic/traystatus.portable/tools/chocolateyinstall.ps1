$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/114/TrayStatus-5.2-x64.zip'
$checksum              = '0dbd027f24adc64231cc12829d28c6f14779f2a1df402e7009025b32b5a469a6'
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
