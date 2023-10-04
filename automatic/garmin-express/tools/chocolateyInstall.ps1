$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = "EXE"
  url           = "https://download.garmin.com/omt/express/GarminExpress.exe"

  checksum      = '3b7d798ad0a8549d8366e79e8ab90d8fdaaefce0f4a6bad3481fb67754787f8e'

  checksumType  = 'sha256'
  silentArgs    = '/quiet /norestart'
}

Install-ChocolateyPackage @packageArgs
