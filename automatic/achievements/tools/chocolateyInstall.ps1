$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/PSerban93/Achievements/releases/download/1.3.3/Achievements-Setup-1.3.3.exe'
$checksum64 = 'd1b7c882a310dc97925d69b7ca50864b05bf01a597a8b4c3e0eebe3093553b4d'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Achievements*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

# The installer cannot replace files of a running Achievements. Stop the app and its helpers, which run from the install folder.
$installPrefix = (Join-Path $env:ProgramFiles 'Achievements') + '\'
Get-Process -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith($installPrefix, [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force

Install-ChocolateyPackage @packageArgs
