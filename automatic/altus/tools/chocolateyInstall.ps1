$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/amanharwara/altus/releases/download/5.8.2/Altus-Setup-5.8.2.exe'
$checksum64 = '63ab96e45201599f360897ee4071a07472352afa6878a8f69388d967b212e648'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Altus*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

# The installer cannot replace files of a running Altus.
Get-Process -Name 'Altus' -ErrorAction SilentlyContinue | Stop-Process -Force

Install-ChocolateyPackage @packageArgs
