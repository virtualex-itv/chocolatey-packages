$ErrorActionPreference = 'Stop'

# Hermes installs to %LOCALAPPDATA%\hermes (or $env:HERMES_HOME) by default and is
# not registered in Add/Remove Programs - the official installer is filesystem-only.
$hermesHome = if ($env:HERMES_HOME) { $env:HERMES_HOME } else { Join-Path $env:LOCALAPPDATA 'hermes' }

# Stop any running Hermes process so file deletion isn't blocked
Get-Process hermes, Hermes -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

if (Test-Path $hermesHome) {
  Write-Host "Removing Hermes install at $hermesHome..."
  Remove-Item $hermesHome -Recurse -Force -ErrorAction SilentlyContinue
} else {
  Write-Warning "Hermes install path not found at $hermesHome - assuming already uninstalled."
}

# Remove the Hermes bin directory from user PATH if the install added it
$userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath) {
  $cleaned = ($userPath -split ';' | Where-Object { $_ -and ($_ -notlike "$hermesHome*") }) -join ';'
  if ($cleaned -ne $userPath) {
    [System.Environment]::SetEnvironmentVariable('Path', $cleaned, 'User')
    Write-Host 'Removed Hermes entries from user PATH.'
  }
}
