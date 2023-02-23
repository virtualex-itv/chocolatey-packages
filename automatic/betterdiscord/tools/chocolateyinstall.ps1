$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/BetterDiscord/Installer/releases/download/v1.2.0/BetterDiscord-Windows.exe'
$checksum               = '62101b7f23db65cdeb32e572b25631aee3e47c41949846c0f9ad3697b86cabbe'
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

if (Get-Process -id $ahkProc.Id -ErrorAction SilentlyContinue) {Stop-Process -id $ahkProc.Id}
