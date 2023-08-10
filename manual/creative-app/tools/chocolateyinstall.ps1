$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://files.creative.com/creative/bin/apps/swureleases/win/creativeapp/release/CreativeAppSetup_1.14.00.00.exe'
$checksum               = '716c92e1bdd4901ae86de65095e82c6b408734e83997005320a0cf98de84196b'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = 'Creative App*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/SP- /VERYSILENT /NORESTART'
  validExitCodes        = @(0, 3010, 1605, 1614, 1641)
}

Install-ChocolateyPackage @packageArgs
