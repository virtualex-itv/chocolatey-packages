$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe'
$checksum              = 'AF161CF7B0F66AD56A147451D7BCDE7868931E9A6F1A1516841A7D5DCCEC4F88'
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
