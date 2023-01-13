$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/116/NotepadReplacerSetup-1.6c.exe'
$checksum              = 'D3115067C131B14E8896C4444BC7E4BDF4075F694E54DC8A3BB6C6177C7AB71E'
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
