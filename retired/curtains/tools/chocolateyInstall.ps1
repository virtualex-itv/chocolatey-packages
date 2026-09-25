$ErrorActionPreference = 'Stop'

Write-Warning "`n ** $($env:ChocolateyPackageName) has been retired and is no longer available for installation. **"
Write-Warning "`n Curtains only works on Windows 10, which reached end of support on October 14, 2025."
Write-Warning " Curtains does NOT work on Windows 11, and Stardock has no plans to support it."
Write-Warning "`n Alternative: WindowBlinds (choco install windowblinds) for Windows UI customization on Windows 10 and 11."
