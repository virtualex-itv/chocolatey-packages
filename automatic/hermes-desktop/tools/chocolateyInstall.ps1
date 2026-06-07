$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$url64      = 'https://hermes-assets.nousresearch.com/Hermes-Setup.exe'
$checksum64 = 'de1de2a339ce52f25fe85cf5098e25269180a3c40d5c26ef4433a2caef58ff91'

# Hermes-Setup.exe is a Tauri-built GUI bootstrap; its embedded tauri.conf.json
# defines no CLI plugin, so there is no silent flag. AutoHotkey drives the
# 3-screen wizard from the outside.
$ahkScript = Join-Path $toolsDir 'hermes-clickthrough.ahk'

# Locate AutoHotkey v2 (AutoHotkey64.exe). The 'autohotkey' meta dependency may
# resolve to either autohotkey.install (Program Files) or autohotkey.portable
# (under choco's lib dir), so search both.
$candidates = @(
  "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe"
  "$env:ProgramFiles\AutoHotkey\AutoHotkey64.exe"
  "$env:ChocolateyInstall\lib\autohotkey.portable\tools\AutoHotkey64.exe"
  "$env:ChocolateyInstall\lib\autohotkey\tools\AutoHotkey64.exe"
)
$ahkExe = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $ahkExe) {
  # Last resort: any AutoHotkey64.exe choco knows about
  $ahkExe = Get-ChildItem "$env:ChocolateyInstall\lib" -Filter 'AutoHotkey64.exe' -Recurse -ErrorAction SilentlyContinue |
            Select-Object -First 1 -ExpandProperty FullName
}
if (-not $ahkExe) {
  throw 'Could not locate AutoHotkey64.exe (v2) from the autohotkey dependency.'
}

# The AHK driver's completion signal is the .hermes-bootstrap-complete marker file
# inside %LOCALAPPDATA%\hermes\hermes-agent. On an upgrade, that file from the prior
# install is still on disk - AHK would see it immediately on its first poll and close
# the wizard before the new install ever runs. Remove it up front so AHK only matches
# a fresh marker dropped by the current install.
$marker = Join-Path $env:LOCALAPPDATA 'hermes\hermes-agent\.hermes-bootstrap-complete'
if (Test-Path $marker) {
  Write-Host "Removing previous bootstrap marker so AHK can detect this install's completion."
  Remove-Item $marker -Force -ErrorAction SilentlyContinue
}

Write-Host "Starting AutoHotkey wizard driver: $ahkScript"
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList $ahkScript -PassThru

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Hermes*'
  silentArgs     = ''
  validExitCodes = @(0, 1)
}

try {
  Install-ChocolateyPackage @packageArgs
} finally {
  if ($ahkProc -and -not $ahkProc.HasExited) {
    Write-Host 'Waiting for click-through driver to finish...'
    $null = $ahkProc | Wait-Process -Timeout 60 -ErrorAction SilentlyContinue
    if (-not $ahkProc.HasExited) {
      Write-Warning 'AutoHotkey driver still running; stopping it.'
      $ahkProc | Stop-Process -Force -ErrorAction SilentlyContinue
    }
  }
}

# Sanity check: did install.ps1 actually succeed?
if (-not (Test-Path $marker)) {
  throw "Hermes install did not complete (marker file missing: $marker). Check %LOCALAPPDATA%\hermes\logs\desktop.log for details."
}
Write-Host 'Hermes install confirmed via bootstrap marker.'
