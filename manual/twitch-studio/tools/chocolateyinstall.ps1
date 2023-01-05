$ErrorActionPreference = 'Stop'

$toolsDir            = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                 = 'https://spotlight-assets.twitchcdn.net/installer/TwitchStudioSetup-network.f826d5292e4b8fbb3fce6f1cd24b2870.exe?context=%5Breferrer-studio_page%5D'
$checksum            = '4E20C96DE6BBC09BB348951C6419A6F46BDDF57A05CF9EF5722B37F569D3F02E'
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
