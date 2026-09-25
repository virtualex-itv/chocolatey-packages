$ErrorActionPreference = 'Stop'

Write-Warning "`n ** $($env:ChocolateyPackageName) has been retired and is no longer available for installation. **"
Write-Warning "`n Start10 was designed for Windows 10, which reached end of support on October 14, 2025."
Write-Warning " Stardock lists Windows 10 as the only supported OS for Start10."
Write-Warning "`n Alternatives: Start11 (choco install start11), StartAllBack (choco install startallback), or Open-Shell (choco install open-shell)."
