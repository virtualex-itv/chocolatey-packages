$ErrorActionPreference = 'Stop'

# Gemini installs per user and registers no Add/Remove Programs entry, so Chocolatey's
# auto uninstaller cannot find it. Run the NSIS uninstaller it ships instead.
$appRoot   = Join-Path (Join-Path $env:LOCALAPPDATA 'Google') 'Gemini'
$uninstall = Join-Path $appRoot 'Uninstall Gemini.exe'

if (-not (Test-Path $uninstall)) {
  Write-Warning "Gemini is not installed under $appRoot - nothing to uninstall."
  return
}

# A running app holds its files open, so the uninstaller cannot remove them.
foreach ($name in 'Gemini', 'GeminiAppLauncher', 'GeminiCrashpadHandler') {
  Get-Process -Name $name -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2

Uninstall-ChocolateyPackage -PackageName $env:ChocolateyPackageName -FileType 'exe' `
  -SilentArgs '/S' -File $uninstall -ValidExitCodes @(0)

# NSIS uninstallers copy themselves to TEMP and exit at once, so wait for the files to go.
$exe      = Join-Path $appRoot 'Gemini.exe'
$deadline = (Get-Date).AddSeconds(90)
while ((Test-Path $exe) -and ((Get-Date) -lt $deadline)) { Start-Sleep -Seconds 2 }
if (Test-Path $exe) { throw "Gemini's uninstaller did not finish removing $appRoot" }

# The app adds itself to the per-user Run key at install time; drop it if it was left behind.
$run   = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
$entry = (Get-ItemProperty -Path $run -Name 'Gemini' -ErrorAction SilentlyContinue).Gemini
if ($entry -and ($entry -like '*Google*Gemini*')) {
  Remove-ItemProperty -Path $run -Name 'Gemini' -ErrorAction SilentlyContinue
}
