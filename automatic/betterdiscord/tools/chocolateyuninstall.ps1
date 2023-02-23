$ErrorActionPreference = 'Stop'

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

Uninstall-ChocolateyInstallPackage @packageArgs

if (Get-Process -id $ahkProc.Id -ErrorAction SilentlyContinue) {Stop-Process -id $ahkProc.Id}
