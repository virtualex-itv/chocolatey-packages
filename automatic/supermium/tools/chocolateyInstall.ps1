$ErrorActionPreference = 'Stop'

$url32      = 'https://github.com/win32ss/supermium/releases/download/v150-r2.01/supermium_150_32_setup.exe'
$checksum32 = 'e86f7fec4b55a8c65842e17252139a757d143a1210de5b8f8ff911a95be009c8'
$url64      = 'https://github.com/win32ss/supermium/releases/download/v150-r2.01/supermium_150_64_setup_win10_11.exe'
$checksum64 = 'e11192d87300a652854c3b28c1290a730509e5ad3c7c096579859dad6139b9cb'

# The installer is a 7-Zip self-extractor around Supermium's own setup: -y answers the
# extractor's prompt, the rest goes to setup (--system-level = all users, --shortcuts = Start menu and desktop).
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Supermium*'
  silentArgs     = '-y --silent --system-level --shortcuts'
  validExitCodes = @(0)
}

# Supermium's setup cannot replace a running copy and shows a modal error instead of failing, so
# close it first: ask nicely (tabs restore), then force. Only the copy under Program Files is touched.
$installDirs = @($env:ProgramW6432, $env:ProgramFiles, ${env:ProgramFiles(x86)}) | Where-Object { $_ } | ForEach-Object { Join-Path $_ 'Supermium' } | Select-Object -Unique
$running = @(Get-Process -ErrorAction SilentlyContinue | Where-Object { $path = $_.Path; $path -and ($installDirs | Where-Object { $path.StartsWith("$_\", [StringComparison]::OrdinalIgnoreCase) }) })
if ($running) {
  Write-Host 'Closing the running Supermium so it can be updated...'
  $running | Where-Object { $_.MainWindowHandle -ne 0 } | ForEach-Object { [void]$_.CloseMainWindow() }
  $running | Wait-Process -Timeout 15 -ErrorAction SilentlyContinue
  $running | Where-Object { -not $_.HasExited } | Stop-Process -Force -ErrorAction SilentlyContinue
}

Install-ChocolateyPackage @packageArgs
