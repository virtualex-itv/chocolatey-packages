Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function Get-Sha256([string]$Url, [string]$Digest) {
  if ($Digest -match '^sha256:(?<sum>[0-9a-fA-F]{64})$') { return $Matches['sum'].ToLower() }
  Get-RemoteChecksum $Url -Algorithm 'sha256'
}

function global:au_GetLatest {
  # The repo also releases the macOS and Linux CLIs, so 'latest' is rarely the Windows build: pick the newest V<x.y.z>-windows tag.
  $request = @{ Uri = 'https://api.github.com/repos/tw93/Mole/releases?per_page=100' }
  if ($env:github_api_key) { $request.Headers = @{ Accept = 'application/vnd.github+json'; Authorization = "Bearer $($env:github_api_key)" } }

  # Assign first: piping Invoke-RestMethod directly passes the JSON array on as a single object.
  $releases = Invoke-RestMethod @request
  $release = $releases |
    Where-Object { -not $_.draft -and -not $_.prerelease -and $_.tag_name -cmatch '^V\d+\.\d+\.\d+-windows$' } |
    Sort-Object { [version]($_.tag_name -replace '^V|-windows$', '') } -Descending |
    Select-Object -First 1
  if (-not $release) { throw "No V<x.y.z>-windows release found in tw93/Mole" }

  $version = $release.tag_name -replace '^V|-windows$', ''
  $assetName = "mole-$version-x64.zip"
  $asset = $release.assets | Where-Object { $_.name -eq $assetName } | Select-Object -First 1
  if (-not $asset) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset '$assetName' in tw93/Mole $($release.tag_name)" }

  @{
    Version      = $version
    URL64        = $asset.browser_download_url
    Digest       = $asset.digest
    ReleaseNotes = "https://github.com/tw93/Mole/releases/tag/$($release.tag_name)"
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = Get-Sha256 $Latest.URL64 $Latest.Digest
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
    'mole.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
