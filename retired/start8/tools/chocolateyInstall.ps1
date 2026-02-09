$ErrorActionPreference = 'Stop'

Write-Warning "`n ** $($env:ChocolateyPackageName) has been retired and is no longer available for installation. **"
Write-Warning "`n Start8 was designed for Windows 8, which reached end of support on January 10, 2023."
Write-Warning " Start8 restores the Windows 7 Start menu on Windows 8, which is not applicable to Windows 10/11."
Write-Warning "`n Alternatives: Start11 (choco install start11) for modern Start menu customization."
