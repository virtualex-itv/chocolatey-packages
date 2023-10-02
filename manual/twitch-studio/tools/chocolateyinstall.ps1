$ErrorActionPreference = 'Stop'

$toolsDir            = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                 = 'https://spotlight-assets.twitchcdn.net/installer/TwitchStudioSetup-network.60de1b5458df05a78a14255cc9d4e017.exe?context=[referrer-studio_page]'
$checksum            = '605feaec7195b07d7ebd6895864881d8db8847739240f0c291ff9d3e4c0690f5'
$checksumType        = 'sha256'

$pp                  = Get-PackageParameters

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  softwareName   = "Twitch Studio*"
  url            = $url
  url64bit       = $url64
  validExitCodes = @(0, 3010)
  silentArgs     = '/silent'
  checksum       = $checksum
  checksumType   = $checksumType
}

Install-ChocolateyPackage @packageArgs
