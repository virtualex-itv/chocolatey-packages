$ErrorActionPreference = 'Stop'

Write-Warning "`n ** $($env:ChocolateyPackageName) has been retired and is no longer available for installation. **"
Write-Warning "`n Twitch Studio was discontinued by Twitch on May 30, 2024."
Write-Warning " The software is no longer available for download."
Write-Warning "`n Alternatives: OBS Studio (choco install obs-studio), Streamlabs (choco install streamlabs-obs), or XSplit (choco install xsplit-broadcaster)"
