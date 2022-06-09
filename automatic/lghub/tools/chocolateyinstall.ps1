$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe'
$checksum              = 'A95EFF397FE2B8EB09FAE554ACA78760B14198E1F3AE47D4BC44824C90233CC2'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName        = $env:ChocolateyPackageName
  unzipLocation      = $toolsDir
  fileType           = 'exe'
  softwareName       = "Logitech G HUB*"
  url                = $url
  checksum           = $checksum
  checksumType       = $checksumType
  silentArgs         = '--silent'
  validExitCodes     = @(0, 3010, 1641)
}

# operating system check
$WindowsVersion=[Environment]::OSVersion.Version
if ($WindowsVersion.Major -ne "10") {
  throw "This package requires Windows 10 or Windows 11."
}

Install-ChocolateyPackage @packageArgs
