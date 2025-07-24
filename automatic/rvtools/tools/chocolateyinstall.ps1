$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.dell.com/rvtools/rvtools4.7.1.msi'
$checksum               = '0506126bcbc4641d41c138e88d9ea9f10fb65f1eeab3bff90ad25330108b324c'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'msi'
  softwareName          = 'RVTools*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = "/qn REBOOT=ReallySuppress"
  validExitCodes        = @(0)
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | ForEach-Object {
    $packageArgs['file'] = "$($_.UninstallString)"
    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"

      $packageArgs['file'] = ''
    }

    Write-Host "`n$env:ChocolateyPackageName installation found, uninstalling prior to upgrade...`n" -ForegroundColor Yellow
    Uninstall-ChocolateyPackage @packageArgs
  }
} else {
  Write-Host "`nNo previous installation of $env:ChocolateyPackageName found, proceeding with installation...`n" -ForegroundColor Green
}

Install-ChocolateyPackage @packageArgs
