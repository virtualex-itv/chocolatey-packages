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

$discordRoot = Join-Path $env:LOCALAPPDATA 'Discord'

# Injection lives in the newest app-*/modules/discord_desktop_core-*/index.js. Discord
# writes a fresh stock copy on every update, which is why BD must be re-run after one.
function Test-BDInjected {
  $app = Get-ChildItem $discordRoot -Filter 'app-*' -Directory -ErrorAction SilentlyContinue |
    Sort-Object Name -Descending | Select-Object -First 1
  if (-not $app) { return $false }
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
