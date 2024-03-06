$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = "EXE"
  url           = "https://download.garmin.com/omt/express/GarminExpress.exe"

  checksum      = '0c6e6b722783025b66d67ab1af7e84ef576002ef756b73c994e299a2062d7add'

  checksumType  = 'sha256'
  silentArgs    = '/quiet /norestart'
}

Install-ChocolateyPackage @packageArgs
