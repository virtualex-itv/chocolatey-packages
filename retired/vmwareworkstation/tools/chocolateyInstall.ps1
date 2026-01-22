$ErrorActionPreference = 'Stop'

Write-Warning "`n ** $($env:ChocolateyPackageName) has been retired and is no longer available for installation. **"
Write-Warning "`n VMware Workstation Pro is now free but requires a Broadcom account to download."
Write-Warning " Please visit https://support.broadcom.com to create an account and download directly."
Write-Warning "`n Alternatives: VirtualBox (choco install virtualbox) or Hyper-V (built into Windows Pro/Enterprise)"
