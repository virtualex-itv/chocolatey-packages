$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = "EXE"
  url           = "https://download.garmin.com/omt/express/GarminExpress.exe"

  checksum      = '6893bdb8edacb7ab2b80add5062aac55201bd4432ed654019929a0d0984cb955'

  checksumType  = 'sha256'
  silentArgs    = '/quiet /norestart'
}

Install-ChocolateyPackage @packageArgs
