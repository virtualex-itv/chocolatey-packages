$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$urlArm64      = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.104.7-arm64.msi'
$checksumArm64 = '904c4d877e306d601ac6dc1216091064769be9c942a2a1acc0cd98ffc6ee9191'
$url32         = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.104.7-x86.msi'
$checksum32    = '54e063e08eb8d618c57be7fd3b82cf4e2d3ab3a95a0b366e113ab01f353d99e5'
$url64         = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.104.7-amd64.msi'
$checksum64    = '676b5b32fdd1aeaee90d8e8f38e222635b216fbdfbf877bf01cb1d7cda330ec5'

$packageArgs = @{
  SoftwareName   = 'Tailscale'
  PackageName    = $env:ChocolateyPackageName
  UnzipLocation  = $toolsDir
  FileType       = 'msi'
  SilentArgs     = '/quiet'
  ValidExitCodes = @(0)
}

if ($env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')) {
  $packageArgs += @{
    Url          = $urlArm64
    Checksum     = $checksumArm64
    ChecksumType = 'sha256'
  }
}
else {
  $packageArgs += @{
    Url            = $url32
    Checksum       = $checksum32
    ChecksumType   = 'sha256'
    Url64Bit       = $url64
    Checksum64     = $checksum64
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
