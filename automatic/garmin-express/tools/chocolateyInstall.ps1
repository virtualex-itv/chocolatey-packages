$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = "EXE"
  url           = "https://download.garmin.com/omt/express/GarminExpress.exe"

  checksum      = 'b727e03c4e1e6b82370adfc8b8335aced3f8f0d5008eacd974985e9faeef6767'

  checksumType  = 'sha256'
  silentArgs    = '/quiet /norestart'
}

Install-ChocolateyPackage @packageArgs
