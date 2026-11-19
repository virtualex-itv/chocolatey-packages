Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

# Meta package: tracks the same release as opentofu.portable and pins its dependency to that exact version.
function global:au_GetLatest {
  $release = Get-GitHubRelease opentofu opentofu
  $version = $release.tag_name.TrimStart('v')

  $name = "tofu_${version}_windows_amd64.zip"
  if (-not ($release.assets | Where-Object { $_.name -eq $name })) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset '$name' in opentofu/opentofu $version" }

  @{
    Version      = $version
    ReleaseNotes = "https://github.com/opentofu/opentofu/releases/tag/$($release.tag_name)"
  }
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
