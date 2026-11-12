Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function global:au_GetLatest {
  # fosrl/windows was renamed to fosrl/windows-linux and now also releases the Linux client, so 'latest' is not always the Windows build: pick the newest windows-<x.y.z> tag.
  $request = @{ Uri = 'https://api.github.com/repos/fosrl/windows-linux/releases?per_page=100' }
  if ($env:github_api_key) { $request.Headers = @{ Accept = 'application/vnd.github+json'; Authorization = "Bearer $($env:github_api_key)" } }

  # Assign first: piping Invoke-RestMethod directly passes the JSON array on as a single object.
  $releases = Invoke-RestMethod @request
  $release = $releases |
    Where-Object { -not $_.draft -and -not $_.prerelease -and $_.tag_name -cmatch '^windows-\d+\.\d+\.\d+$' } |
    Sort-Object { [version]($_.tag_name -replace '^windows-', '') } -Descending |
    Select-Object -First 1
  if (-not $release) { throw "No windows-<x.y.z> release found in fosrl/windows-linux" }

  $version = $release.tag_name -replace '^windows-', ''
  $asset = $release.assets | Where-Object { $_.name -match 'pangolin-amd64-.*\.msi$' } | Select-Object -First 1
  if (-not $asset) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset matching 'pangolin-amd64-*.msi' in fosrl/windows-linux $($release.tag_name)" }
  $Url64 = $asset.browser_download_url

  return @{
    Version = $version
    Url64   = $Url64
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64 -Algorithm 'sha256'
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.Url64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
