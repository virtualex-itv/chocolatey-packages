$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/114/TrayStatus-5.1.2-x64.zip'
$checksum              = '0b1f462ec0d32bbad92e10cc9e37698487eef786b0f37e97966810988d3160d1'
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
