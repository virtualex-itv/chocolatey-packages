$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/PSerban93/Achievements/releases/download/1.3.1/Achievements-Setup-1.3.1.exe'
$checksum64 = 'b39b58626c57ec8dd16a4614cef1390bb49f58ab7db379590fd1e0ab472fefdc'

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
