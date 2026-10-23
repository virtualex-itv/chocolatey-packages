$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/SECHAK-AG/capptivo/releases/download/v1.0.4/Capptivo_1.0.4_x64_en-US.msi'
$checksum64 = 'bba18d4d6739c9e8fb29757c7f3343d79fee4a4f445e597fd7f5364a4d11575f'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Capptivo*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
