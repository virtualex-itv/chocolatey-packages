Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

# Meta package: tracks the same releases as opentofu.portable (one stream per minor) and pins its dependency to that exact version.
$StreamCount = 2

function Get-LatestPerMinor {
  $headers = @{}
  if ($env:github_api_key) { $headers.Authorization = "token $env:github_api_key" }
  $releases = Invoke-RestMethod 'https://api.github.com/repos/opentofu/opentofu/releases?per_page=50' -Headers $headers
  $releases | Where-Object { -not $_.prerelease -and -not $_.draft -and $_.tag_name -match '^v\d+\.\d+\.\d+$' } |
    Group-Object { ($_.tag_name.TrimStart('v') -split '\.')[0..1] -join '.' } |
    Sort-Object { [version]$_.Name } -Descending |
    Select-Object -First $StreamCount |
    ForEach-Object { $_.Group | Sort-Object { [version]$_.tag_name.TrimStart('v') } -Descending | Select-Object -First 1 }
}

function global:au_GetLatest {
  $streams = [ordered]@{}
  foreach ($release in Get-LatestPerMinor) {
    $version = $release.tag_name.TrimStart('v')
    $minor = ($version -split '\.')[0..1] -join '.'

    $name = "tofu_${version}_windows_amd64.zip"
    if (-not ($release.assets | Where-Object { $_.name -eq $name })) {
      if (Test-ReleaseAssetsPending $release) { $streams[$minor] = 'ignore'; continue }
      throw "No asset '$name' in opentofu/opentofu $version"
    }

    $streams[$minor] = @{
      Version      = $version
      ReleaseNotes = "https://github.com/opentofu/opentofu/releases/tag/$($release.tag_name)"
    }
  }
  @{ Streams = $streams }
}

function global:au_SearchReplace {
  @{
    'opentofu.nuspec' = @{
      '(<dependency id="opentofu.portable" version=)"[^"]+"' = "`${1}`"[$($Latest.Version)]`""
      '(<releaseNotes>)[^<]*(</releaseNotes>)'               = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
