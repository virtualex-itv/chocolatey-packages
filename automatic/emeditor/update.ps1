Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

# The vendor's own "latest" endpoint redirects to the versioned MSI, so the version and the URL come from one place.
$latestUrl = 'https://support.emeditor.com/en/downloads/latest/installer'

function global:au_GetLatest {
  $request = [System.Net.HttpWebRequest]::Create($latestUrl)
  $request.Method = 'HEAD'
  $request.AllowAutoRedirect = $false
  try {
    $response = $request.GetResponse()
    $location = $response.Headers['Location']
  } finally {
    if ($response) { $response.Dispose() }
  }

  if ($location -notmatch '/emed64_(?<version>\d+\.\d+\.\d+)\.msi$') { throw "Unexpected redirect from ${latestUrl}: $location" }

  @{
    Version = $Matches['version']
    URL64   = $location
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64 -Algorithm 'sha256'
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
