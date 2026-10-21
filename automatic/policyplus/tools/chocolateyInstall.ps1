$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url      = ''
$checksum = ''

$exe = Join-Path $toolsDir 'PolicyPlus.exe'

Get-ChocolateyWebFile -PackageName $env:ChocolateyPackageName -FileFullPath $exe -Url $url -Checksum $checksum -ChecksumType 'sha256'

# Policy Plus is a GUI app: the .gui marker makes Chocolatey create a non-blocking shim.
New-Item -ItemType File -Path "$exe.gui" -Force | Out-Null

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonPrograms')) 'Policy Plus.lnk'
Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $exe