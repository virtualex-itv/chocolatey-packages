$ErrorActionPreference = 'Stop'

# chocolateyBeforeModify.ps1 stops Cypress and removes the app folder; the shortcut is all that is left.
Remove-Item (Join-Path ([Environment]::GetFolderPath('Desktop')) 'Cypress.lnk') -Force -ErrorAction SilentlyContinue
