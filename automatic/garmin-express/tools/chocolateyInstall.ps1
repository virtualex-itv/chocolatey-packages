$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = "EXE"
  url           = "https://download.garmin.com/omt/express/GarminExpress.exe"

  checksum      = 'c828c9598a24ef367b1a4240724a729dfa2dd46fa98be9cdbe1a235903cf1481'

  checksumType  = 'sha256'
  silentArgs    = '/quiet /norestart'
}

Install-ChocolateyPackage @packageArgs
