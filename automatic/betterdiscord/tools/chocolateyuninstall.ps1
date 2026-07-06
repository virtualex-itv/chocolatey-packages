$ErrorActionPreference = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  fileType              = 'exe'
  file                  = Get-Item $toolsDir\*.exe
  softwareName          = 'BetterDiscord*'
  silentArgs            = ""
  validExitCodes        = @(0, 3010, 1605, 1614, 1641)
}

# silent uninstall requires AutoHotKey
$ahkFile  = Join-Path $toolsDir 'chocolateyUninstall.ahk'
$ahkExe   = Get-ChildItem "$env:ChocolateyInstall\lib\autohotkey.portable" -Recurse -filter autohotkey.exe
$ahkProc  = Start-Process -FilePath $ahkEXE.FullName -ArgumentList $ahkFile -PassThru

Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

Uninstall-ChocolateyPackage @packageArgs

# Give the AHK script time to click Close and exit on its own; force-kill
# only if it is still running after the grace period. The uninstaller is an
# NSIS stub that can exit before the child UI window is closed, so killing
# AHK immediately here races its final Close click.
if (-not $ahkProc.WaitForExit(60000)) {
  Stop-Process -Id $ahkProc.Id -ErrorAction SilentlyContinue
}
