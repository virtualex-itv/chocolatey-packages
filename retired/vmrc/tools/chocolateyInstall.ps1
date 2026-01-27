$ErrorActionPreference = 'Stop'

Write-Warning "`n ** $($env:ChocolateyPackageName) has been retired and is no longer available for installation. **"
Write-Warning "`n VMware Remote Console (VMRC) is still free but requires a Broadcom account to download."
Write-Warning " Please visit https://support.broadcom.com to create an account and download directly."
Write-Warning "`n For macOS users, VMRC can be installed directly from the App Store."
