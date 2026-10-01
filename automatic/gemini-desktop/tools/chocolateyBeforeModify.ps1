$ErrorActionPreference = 'Stop'

# A running app keeps the old version loaded and shows "Update Ready" once the new build lands,
# so stop it before an upgrade or uninstall replaces the files.
foreach ($name in 'Gemini', 'GeminiAppLauncher', 'GeminiCrashpadHandler') {
  Get-Process -Name $name -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Seconds 2
