$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/101/DisplayFusion-11.0.1-x64.zip'
$checksum              = 'cac5249ffb16c931618556357efdeecc6fce7d4f5812748386f7f53dce9589f2'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName          = $env:ChocolateyPackageName
  unzipLocation        = $toolsDir
  url                  = $url
  checksum             = $checksum
  checksumType         = $checksumType
}

Install-ChocolateyZipPackage @packageArgs
