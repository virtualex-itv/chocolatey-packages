$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.dell.com/rvtools/rvtools4.8.2.msi'
$checksum               = 'a3f72e51f08b0308d2a85844c1b61d698e8b823cb3c0e3cb6bf3e8f5eb4dc01e'
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
