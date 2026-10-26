$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64      = 'https://github.com/AyuGram/AyuGramDesktop/releases/download/v7.2.9/AyuGram.zip'
$checksum64 = '69aab831164169a6713314bb06792314d4e3af8fba6f1cfbdf2cdcbf44364684'

# The files cannot be replaced while AyuGram or its updater runs from the tools folder.
Get-Process -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith("$toolsDir\", [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

# Put back the data that chocolateyBeforeModify.ps1 saved before the old folder was removed.
$data = Join-Path $toolsDir 'tdata'
$backup = Join-Path $env:ProgramData 'AyuGram-tdata-backup'
if (Test-Path $backup) {
  if (-not (Test-Path $data)) { Move-Item $backup $data } else { Remove-Item $backup -Recurse -Force }
}

# AyuGram.exe is a GUI app, so its shim must not block the console; Updater.exe is not meant to be run from a shim.
New-Item -ItemType File -Path (Join-Path $toolsDir 'AyuGram.exe.gui') -Force | Out-Null
New-Item -ItemType File -Path (Join-Path $toolsDir 'Updater.exe.ignore') -Force | Out-Null

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonPrograms')) 'AyuGram.lnk'
Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath (Join-Path $toolsDir 'AyuGram.exe')
