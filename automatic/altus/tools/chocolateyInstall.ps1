$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/amanharwara/altus/releases/download/5.8.1/Altus-Setup-5.8.1.exe'
$checksum64 = 'd0118d6f3b846038847b45ee9fa90ed3b612c75f1d452b022b33a1e8df1a9033'

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
