$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/116/NotepadReplacerSetup-1.5.exe'
$checksum              = 'cd758294854b59f2dd86574643b9d986bb1c222eb212ab26c1839a7111c84cd7'
$checksumType          = 'sha256'
$pp                    = Get-PackageParameters

if ( $pp.NOTEPAD ) {
  $notepadDir = $pp.NOTEPAD
  Write-Host "`nSetting $notepadDir as the default notepad application...`n" -ForegroundColor Yellow

  $packageArgs = @{
    packageName        = $env:ChocolateyPackageName
    unzipLocation      = $toolsDir
    fileType           = 'exe'
    softwareName       = "Notepad Replacer*"
    url                = $url
    checksum           = $checksum
    checksumType       = $checksumType
    silentArgs         = '/NOTEPAD="' + $notepadDir + '" /VERYSILENT'
    validExitCodes     = @(0, 3010)
  }

  Install-ChocolateyPackage @packageArgs
  } else {
    Set-PowerShellExitCode 1
    throw '/NOTEPAD parameter and application path required...
    example: choco install notepadreplacer --params=''"/NOTEPAD:C:\Program Files\Notepad++\notepad++.exe"'''
	  exit
}
