$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://geekuninstaller.com/geek.zip'
$checksum              = '44ed57036b0f176242a9f7b9094e68a5013a686c479b6ba4c06a284ce97c5750'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName          = $env:ChocolateyPackageName
  unzipLocation        = $toolsDir
  url                  = $url
  checksum             = $checksum
  checksumType         = $checksumType
}

Install-ChocolateyZipPackage @packageArgs
