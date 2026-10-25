$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://dl4jz3rbrsfum.cloudfront.net/software/PPP_Windows_v2.7.2.exe'
$checksum               = '55f91efb8f22a6494561b671f9e7b8c4efc6cbc4438799b60214d3f131119747'
$checksumType           = 'sha256'

$file = Join-Path $toolsDir 'PPP_Windows.exe'

Get-ChocolateyWebFile -PackageName $env:ChocolateyPackageName -FileFullPath $file -Url $url -Checksum $checksum -ChecksumType $checksumType

# The installer launches the app, which would hold Chocolatey's output pipe open and hang a non-interactive install, so run it without inheriting handles.
$process = Start-Process -FilePath $file -ArgumentList '-q' -PassThru
$process.WaitForExit()
# The installer's helper processes can keep the file open for a few seconds.
for ($i = 0; $i -lt 10 -and (Test-Path $file); $i++) {
  Remove-Item $file -Force -ErrorAction SilentlyContinue
  if (Test-Path $file) { Start-Sleep -Seconds 3 }
}
if ($process.ExitCode -ne 0) { throw "PowerPanel Personal setup failed with exit code $($process.ExitCode)." }
