Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

# Paragon replaces its unversioned installers in place and the page shows only the UI version, which does not match
# the installer's. The version is read from the downloaded x64 exe, guarded by an ETag + Content-Length HEAD check
# on both installers so the ~135 MB download only happens when Paragon replaces a file.
$releases = 'https://www.paragon-software.com/free/pm-express/'

function Get-HeadInfo([string]$Url) {
  $request = [System.Net.WebRequest]::CreateDefault($Url)
  $request.Method = 'HEAD'
  try {
    $response = $request.GetResponse()
    @{ ETag = $response.Headers.Get('ETag'); Length = $response.ContentLength.ToString() }
  } finally {
    if ($response) { $response.Dispose() }
  }
}

function Get-InstallerInfo([string]$Url) {
  $dest = Join-Path $env:TEMP (Split-Path -Leaf $Url)
  Invoke-WebRequest -Uri $Url -OutFile $dest -UseBasicParsing
  $version = (Get-Command $dest).FileVersionInfo.ProductVersion
  if (-not $version) { throw "Could not read a version from $Url" }
  $sha256 = (Get-FileHash $dest -Algorithm SHA256).Hash.ToLower()
  Remove-Item $dest -Force -ErrorAction SilentlyContinue
  @{ Version = $version.Trim(); Checksum = $sha256 }
}

function global:au_GetLatest {
  $page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $url64 = $page.Links.href | Where-Object { $_ -match 'WinInstallDemo_x64\.exe$' } | Select-Object -First 1
  $urlArm64 = $page.Links.href | Where-Object { $_ -match 'WinInstallDemo_arm64\.exe$' } | Select-Object -First 1
  if (-not $url64) { throw "No x64 installer link found on $releases" }
  if (-not $urlArm64) { throw "No ARM64 installer link found on $releases" }

  $head64 = Get-HeadInfo $url64
  $headArm64 = Get-HeadInfo $urlArm64

  # Info file: x64 ETag|Version|x64 Content-Length|ARM64 ETag|ARM64 Content-Length
  $saveFile = '.\info'
  if ((Test-Path $saveFile) -and !$global:au_Force) {
    $info = (Get-Content $saveFile -Encoding UTF8 -TotalCount 1) -split '\|'
    if ($info.Count -gt 4 -and $info[0] -eq $head64.ETag -and $info[2] -eq $head64.Length -and $info[3] -eq $headArm64.ETag -and $info[4] -eq $headArm64.Length) {
      return @{ Version = $info[1]; URL64 = $url64; UrlArm64 = $urlArm64 }
    }
  }

  $x64 = Get-InstallerInfo $url64
  $arm64 = Get-InstallerInfo $urlArm64
  # Paragon may refresh one installer before the other; pairing mismatched builds would break the package.
  if ($x64.Version -ne $arm64.Version) {
    Write-Warning "x64 ($($x64.Version)) and ARM64 ($($arm64.Version)) installers differ; waiting for both to match"
    return 'ignore'
  }

  "$($head64.ETag)|$($x64.Version)|$($head64.Length)|$($headArm64.ETag)|$($headArm64.Length)" | Out-File $saveFile -Encoding utf8 -NoNewline

  # The URLs are unversioned: a replaced installer with the same version would leave a stale checksum in the package.
  $install = Get-Content "$PSScriptRoot\tools\chocolateyInstall.ps1" -Raw
  foreach ($pair in @(@('checksum64', $x64.Checksum), @('checksumArm64', $arm64.Checksum))) {
    $current = [regex]::Match($install, ('(?m)^\$' + $pair[0] + '\s*=\s*''([0-9a-fA-F]{64})''')).Groups[1].Value
    if ($current -and $current -ne $pair[1]) {
      Write-Host "$($pair[0]) changed without a version bump - forcing update"
      $global:au_Force = $true
    }
  }

  @{
    Version        = $x64.Version
    URL64          = $url64
    UrlArm64       = $urlArm64
    Checksum64     = $x64.Checksum
    ChecksumArm64  = $arm64.Checksum
  }
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"          = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"     = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\`$urlArm64\s*=\s*)'.*'"       = "`${1}'$($Latest.UrlArm64)'"
      "(?i)(^\`$checksumArm64\s*=\s*)'.*'"  = "`${1}'$($Latest.ChecksumArm64)'"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
