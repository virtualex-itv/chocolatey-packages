Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

# Official short links from https://docs.sharefile.com/en-us/sharefile/sharefile-downloads; each redirects to a versioned file name.
$links = @{
  x64   = 'https://dl.sharefile.com/sfwin-msi-x64'
  arm64 = 'https://dl.sharefile.com/sfwin-msi-arm64'
}

# Reads the redirect target WITHOUT following it.
function Get-RedirectTarget([string]$Url) {
  $request = [System.Net.HttpWebRequest]::Create($Url)
  $request.Method = 'HEAD'
  $request.AllowAutoRedirect = $false
  try {
    $response = $request.GetResponse()
    $location = $response.Headers['Location']
  } finally {
    if ($response) { $response.Dispose() }
  }
  if ($location -notmatch '_v(?<version>\d+(\.\d+){1,3})\.msi$') { throw "Unexpected redirect from ${Url}: $location" }
  # The Location header is relative (/sfwin-msi-x64/...)
  @{ Url = ([Uri]::new([Uri]$Url, $location)).AbsoluteUri; Version = $Matches['version'] }
}

function global:au_GetLatest {
  $x64   = Get-RedirectTarget $links.x64
  $arm64 = Get-RedirectTarget $links.arm64
  if ($x64.Version -ne $arm64.Version) { throw "x64 link serves $($x64.Version) but ARM64 link serves $($arm64.Version)" }

  @{
    Version  = $x64.Version
    URL64    = $x64.Url
    URLArm64 = $arm64.Url
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64    = Get-RemoteChecksum $Latest.URL64 -Algorithm 'sha256'
  $Latest.ChecksumArm64 = Get-RemoteChecksum $Latest.URLArm64 -Algorithm 'sha256'
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"         = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"    = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\`$urlArm64\s*=\s*)'.*'"      = "`${1}'$($Latest.URLArm64)'"
      "(?i)(^\`$checksumArm64\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumArm64)'"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
