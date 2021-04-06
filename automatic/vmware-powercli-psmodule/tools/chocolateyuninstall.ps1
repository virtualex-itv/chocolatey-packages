$ErrorActionPreference = 'Stop'

$shortcutName = 'VMware.PowerCLI.lnk'

Get-InstalledModule -Name "VMware.*" |  Uninstall-Module -AllVersions -Force

Remove-Item "$ENV:Public\Desktop\$shortcutName" -Force -ErrorAction SilentlyContinue
Remove-Item "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -Force -ErrorAction SilentlyContinue
