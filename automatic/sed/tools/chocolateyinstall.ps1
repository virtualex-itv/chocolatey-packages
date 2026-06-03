$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://github.com/mbuilov/sed-windows/releases/download/sed-4.9-x64-fixed/sed-4.9-x86.exe'
$checksum              = '7b31b07ebffa675f85b27908e9f3eb8ef57ec297c289942f6cd2a40eee8f88b3'
$ChecksumType          = 'sha256'
$url64                 = 'https://github.com/mbuilov/sed-windows/releases/download/sed-4.9-x64-fixed/sed-4.9-x64.exe'
$checksum64            = '38fbdb237afaf25fdaee462c6504d61ce7dd122db0206b353df1a29e5b0aa7c5'
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
