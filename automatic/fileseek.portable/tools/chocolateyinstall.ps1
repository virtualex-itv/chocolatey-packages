$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/103/FileSeek-6.6.zip'
$checksum              = 'e2c5114d0f523316cd3504a1b2a2f50a720f3bba37688382035f245304d2fd97'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName          = $env:ChocolateyPackageName
  unzipLocation        = $toolsDir
  fileType             = 'exe'
  softwareName         = 'FileSeek*'
  url                  = $url
  checksum             = $checksum
  checksumType         = $checksumType
  silentArgs           = "/qn /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log`""
  validExitCodes       = @(0, 3010, 1641)
}

Install-ChocolateyZipPackage @packageArgs
