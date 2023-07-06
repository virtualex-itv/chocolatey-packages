$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download01.logi.com/web/ftp/pub/techsupport/optionsplus/logioptionsplus_installer.exe'
$checksum              = 'D12A5C75119040D204753E6A549821A823BA239DCF917273E460ED545134875E'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName        = $env:ChocolateyPackageName
  unzipLocation      = $toolsDir
  fileType           = 'exe'
  softwareName       = "Logi Options+*"
  url                = $url
  checksum           = $checksum
  checksumType       = $checksumType
  silentArgs         = '/quiet'
  validExitCodes     = @(0, 3010, 1641)
}

# operating system check
$WindowsVersion=[Environment]::OSVersion.Version
if ($WindowsVersion.Major -ne "10") {
  throw "This package requires Windows 10 or Windows 11."
}

Install-ChocolateyPackage @packageArgs
