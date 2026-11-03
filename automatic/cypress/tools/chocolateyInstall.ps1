$ErrorActionPreference = 'Stop'

$url64      = ''
$checksum64 = ''

$installDir = Join-Path (Get-ToolsLocation) 'Cypress'

# An upgrade from the older package reaches this point with Cypress still running, since its before-modify script never stopped it.
if (Test-Path $installDir) {
  Get-Process -ErrorAction SilentlyContinue |
    Where-Object { $_.Path -and $_.Path.StartsWith($installDir + '\', [StringComparison]::OrdinalIgnoreCase) } |
    Stop-Process -Force -PassThru |
    Wait-Process -Timeout 15 -ErrorAction SilentlyContinue
  Remove-Item $installDir -Recurse -Force
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = Get-ToolsLocation
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

$exe = Join-Path $installDir 'Cypress.exe'
if (-not (Test-Path $exe)) { throw "Cypress.exe was not found in '$installDir' after extraction" }

Install-ChocolateyShortcut `
  -ShortcutFilePath (Join-Path ([Environment]::GetFolderPath('Desktop')) 'Cypress.lnk') `
  -TargetPath $exe
