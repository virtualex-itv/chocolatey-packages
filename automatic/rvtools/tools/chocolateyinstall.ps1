$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://robware.net/download/c2f0942d59a42901b18e06ea73a4dc4be8e57670c8973429c5ba5da99f60580412/RVTools4.1.3.msi'
$checksum               = 'bdb0b27097dc3e6140987ab44dadd7f65bd4834bdd21b0534a20083ce9af41b2'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'msi'
  softwareName          = 'RVTools*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = "/qn REBOOT=ReallySuppress"
  validExitCodes        = @(0)
}

Install-ChocolateyPackage @packageArgs
