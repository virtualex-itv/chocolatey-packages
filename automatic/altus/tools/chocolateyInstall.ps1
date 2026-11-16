$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/amanharwara/altus/releases/download/5.8.3/Altus-Setup-5.8.3.exe'
$checksum64 = '8da85b6ade85c6e7d01ce8f482b0c628861350d1d18178c805cd73871bc7ddc8'

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
