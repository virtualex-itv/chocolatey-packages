$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://github.com/mbuilov/sed-windows/releases/download/sed-4.9/sed-4.9-x86.exe'
$checksum              = '7b31b07ebffa675f85b27908e9f3eb8ef57ec297c289942f6cd2a40eee8f88b3'
$ChecksumType          = 'sha256'
$url64                 = 'https://github.com/mbuilov/sed-windows/releases/download/sed-4.9/sed-4.9-x64.exe'
$checksum64            = '55252fc023b7092d8f39b209a33ae2d56558a541ea6606af53e00c37f1296163'
$ChecksumType64        = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  fileFullPath          = "$toolsDir\sed.exe"
  url                   = $url
  url64                 = $url64
  checksum              = $checksum
  checksum64            = $checksum64
  checksumType          = $checksumType
  checksumType64        = $checksumType64
}

Get-ChocolateyWebFile @packageArgs
