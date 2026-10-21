$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url32      = 'https://github.com/charmbracelet/gum/releases/download/v2.0.2/gum_2.0.2_Windows_i386.zip'
$checksum32 = '0c2c172568c9ae6d059ca7fe3ef08fc9f5b2842cbbf813c33dfd1985aba01037'
$url64      = 'https://github.com/charmbracelet/gum/releases/download/v2.0.2/gum_2.0.2_Windows_x86_64.zip'
$checksum64 = '0397091dec9b4e8f00e02b90fd3eb07bf45acabbdb61d67437950f18e03a8b79'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
