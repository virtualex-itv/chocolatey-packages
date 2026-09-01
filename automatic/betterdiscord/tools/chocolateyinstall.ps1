$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/BetterDiscord/Installer/releases/download/v2.0.0/BetterDiscord-Installer-Windows.exe'
$checksum               = '2eda2104c900a77fbb0568ade67becda3c087ffcbb7a267f3f8e512c18270432'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  fileFullPath          = "$toolsDir\BetterDiscord.exe"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
}

Get-ChocolateyWebFile @packageArgs

$discordRoot = Join-Path $env:LOCALAPPDATA 'Discord'

# BD 2.0.0 injects with the app.asar method: a resources\app shim (index.js plus a
# package.json pointing at it) that loads betterdiscord.app.asar. BD 1.x instead
# patched discord_desktop_core's index.js, which 2.x never touches - checking only the
# old site reports a false failure on every 2.x install. Discord restores both on
# update, which is why BD must be re-run after one.
function Test-BDInjected {
  $app = Get-ChildItem $discordRoot -Filter 'app-*' -Directory -ErrorAction SilentlyContinue |
    Sort-Object Name -Descending | Select-Object -First 1
  if (-not $app) { return $false }

  $shim = Join-Path $app.FullName 'resources\app\index.js'
  if ((Test-Path $shim) -and ((Get-Content $shim -Raw) -match 'betterdiscord')) { return $true }

  $core = Get-ChildItem (Join-Path $app.FullName 'modules') -Filter 'discord_desktop_core-*' -Directory -ErrorAction SilentlyContinue |
    Sort-Object Name -Descending | Select-Object -First 1
  if (-not $core) { return $false }
  $idx = Join-Path $core.FullName 'discord_desktop_core\index.js'
  return (Test-Path $idx) -and ((Get-Content $idx -Raw) -match 'betterdiscord')
}


# BD injects into a stopped Discord; remember whether to bring it back afterwards.
$discordWasRunning = [bool](Get-Process 'discord' -ErrorAction SilentlyContinue)
Get-Process 'discord' -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

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

# The NSIS stub can exit before its child UI closes, so give AHK time to finish.
if (-not $ahkProc.WaitForExit(60000)) {
  Stop-Process -Id $ahkProc.Id -ErrorAction SilentlyContinue
}

# The installer writes the injection asynchronously; poll before judging it failed.
$deadline = (Get-Date).AddSeconds(60)
while (-not (Test-BDInjected) -and (Get-Date) -lt $deadline) { Start-Sleep -Seconds 2 }
$injected = Test-BDInjected

if ($discordWasRunning) {
  Start-Process (Join-Path $discordRoot 'Update.exe') -ArgumentList '--processStart', 'Discord.exe' -ErrorAction SilentlyContinue
}

if (-not $injected) {
  throw "BetterDiscord did not inject into Discord - the installer window likely closed before finishing. Run BetterDiscord.exe from $toolsDir manually to complete the install."
}
