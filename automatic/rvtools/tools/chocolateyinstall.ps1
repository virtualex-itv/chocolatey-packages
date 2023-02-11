$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://robware.net/download/c2f0942d59a42901b18e06ea73a4dc4be8e57670c8973429c5ba5da99f60580412/RVTools4.4.1.msi'
$checksum               = '854139a19bb1c584c246c09ca3c2615ebc545d7e09acc5108ab253fec609c1f7'
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
