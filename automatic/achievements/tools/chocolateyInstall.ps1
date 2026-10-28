$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/PSerban93/Achievements/releases/download/1.3.2/Achievements-Setup-1.3.2.exe'
$checksum64 = '4f6fd0860abd544ef62947035dcf427dd48491b3d88e3d5f7804c950acfb4a71'

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
