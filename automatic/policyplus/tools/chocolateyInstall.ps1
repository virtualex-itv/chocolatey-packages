$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url      = 'https://github.com/Fleex255/PolicyPlus/releases/download/October2025/PolicyPlus.exe'
$checksum = '28c86dc782966929b09e951f0580826027c0b80e9ba38868e1fc6811dfb8bade'

$exe = Join-Path $toolsDir 'PolicyPlus.exe'

Get-ChocolateyWebFile -PackageName $env:ChocolateyPackageName -FileFullPath $exe -Url $url -Checksum $checksum -ChecksumType 'sha256'

# Policy Plus is a GUI app: the .gui marker makes Chocolatey create a non-blocking shim.
New-Item -ItemType File -Path "$exe.gui" -Force | Out-Null

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonPrograms')) 'Policy Plus.lnk'
Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $exe
