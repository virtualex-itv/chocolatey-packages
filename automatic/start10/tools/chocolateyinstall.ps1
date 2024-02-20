$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/start/Start10_setup_sd.exe'
$checksum               = '5e601491fa0beea4de519e5a7c2ec7203686021d821b4f3e2ec53e925cd13702'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock Start10*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

$OSVer = ((Get-WmiObject Win32_OperatingSystem).Version).Split('.')[0]
$OSInfo = (Get-WmiObject Win32_OperatingSystem).ProductType

If ( ($OSVer -ne '10') -and ($OSInfo -ne '1') ) {
  Write-Warning "*** Stardock $($packageName.substring(0,1).toupper()+$packageName.substring(1).tolower()) requires a desktop OS running Windows 10... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
