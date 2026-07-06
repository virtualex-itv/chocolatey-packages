$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/BetterDiscord/Installer/releases/download/v1.3.0/BetterDiscord-Windows.exe'
$checksum               = '249bdaa4332b3e1a3a2148d4fd587a42bd48615af556d1c72da51c55bb2ca697'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  fileFullPath          = "$toolsDir\BetterDiscord.exe"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
}

Get-ChocolateyWebFile @packageArgs

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  fileType              = 'exe'
  file                  = Get-Item $toolsDir\*.exe
  softwareName          = 'BetterDiscord*'
  silentArgs            = ""
  validExitCodes        = @(0, 3010, 1605, 1614, 1641)
}

# silent install requires AutoHotKey
$ahkFile  = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkExe   = Get-ChildItem "$env:ChocolateyInstall\lib\autohotkey.portable" -Recurse -filter autohotkey.exe
$ahkProc  = Start-Process -FilePath $ahkEXE.FullName -ArgumentList $ahkFile -PassThru

Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

Install-ChocolateyInstallPackage @packageArgs

# Give the AHK script time to click Close and exit on its own; force-kill
# only if it is still running after the grace period. The installer is an
# NSIS stub that can exit before the child UI window is closed, so killing
# AHK immediately here races its final Close click.
if (-not $ahkProc.WaitForExit(60000)) {
  Stop-Process -Id $ahkProc.Id -ErrorAction SilentlyContinue
}
