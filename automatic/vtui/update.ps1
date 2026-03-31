Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function global:au_GetLatest {
  $release = Get-GitHubRelease noclue vtui
  $version = $release.tag_name.TrimStart('v')

  $url64    = $release.assets | Where-Object { $_.name -eq 'vtui-x86_64-pc-windows-msvc.zip' }    | Select-Object -ExpandProperty browser_download_url -First 1
  $urlArm64 = $release.assets | Where-Object { $_.name -eq 'vtui-aarch64-pc-windows-msvc.zip' }   | Select-Object -ExpandProperty browser_download_url -First 1

  @{
    Version   = $version
    URL64     = $url64
    URLArm64  = $urlArm64
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64    = ([System.Text.Encoding]::UTF8.GetString((Invoke-WebRequest -Uri "$($Latest.URL64).sha256"    -UseBasicParsing).Content).Trim() -split '\s+')[0].ToLower()
  $Latest.ChecksumArm64 = ([System.Text.Encoding]::UTF8.GetString((Invoke-WebRequest -Uri "$($Latest.URLArm64).sha256" -UseBasicParsing).Content).Trim() -split '\s+')[0].ToLower()
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"          = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"     = "`${1}'$($Latest.Checksum64)'"
      "(?i)(^\`$urlArm64\s*=\s*)'.*'"       = "`${1}'$($Latest.URLArm64)'"
      "(?i)(^\`$checksumArm64\s*=\s*)'.*'"  = "`${1}'$($Latest.ChecksumArm64)'"
    }
    'vtui.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}https://github.com/noclue/vtui/releases/tag/v$($Latest.Version)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoCheckChocoVersion
