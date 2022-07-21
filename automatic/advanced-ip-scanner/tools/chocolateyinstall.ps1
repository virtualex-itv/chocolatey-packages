$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download.advanced-ip-scanner.com/download/files/Advanced_IP_Scanner_2.5.4594.1.exe'
$checksum               = '26d5748ffe6bd95e3fee6ce184d388a1a681006dc23a0f08d53c083c593c193b'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Advanced IP Scanner*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes        = @(0)
}

Install-ChocolateyPackage @packageArgs
