$ErrorActionPreference = 'Stop'

$url64      = ''
$checksum64 = ''

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Stirling PDF*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

# The installer cannot replace files of a running app. Stop whatever runs from the install folder
# (the app and its bundled Java backend), not by a guessed process name.
$installPrefix = (Join-Path $env:ProgramFiles 'Stirling PDF') + '\'
Get-Process -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith($installPrefix, [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force

Install-ChocolateyPackage @packageArgs
