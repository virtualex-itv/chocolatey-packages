$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/126/WindowInspectorSetup-3.0c.exe'
$checksum              = '75417f1855093e144c49c112860044123ee767819335ec04ff5f173cd0554d6b'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName          = $env:ChocolateyPackageName
  unzipLocation        = $toolsDir
  fileType             = 'exe'
  softwareName         = 'WindowInspector*'
  url                  = $url
  checksum             = $checksum
  checksumType         = $checksumType
  silentArgs           = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes       = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
