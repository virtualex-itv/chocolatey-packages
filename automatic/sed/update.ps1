Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$release = Get-GitHubRelease mbuilov sed-windows

function global:au_GetLatest {
  $Url32 = $release.assets | ? {$_.name -match 'x86' } | ? { $_.name.endswith('.exe') } | select -First 1 -ExpandProperty browser_download_url
  $Url64 = $release.assets | ? {$_.name -match 'x64' } | ? { $_.name.endswith('.exe') } | select -First 1 -ExpandProperty browser_download_url

  $version = $release.tag_name.Trim('sed-')
  $ChecksumType = 'sha256'

  $tag = $release.tag_name
  $ReleaseNotes = "https://github.com/mbuilov/sed-windows/releases/tag/$($tag)"

  @{
    Url32             = $Url32
    Url64             = $Url64
    Version           = $version
    ChecksumType32    = $ChecksumType
    ChecksumType64    = $ChecksumType
    ReleaseNotes      = $ReleaseNotes
  }
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"            = "`$1'$($Latest.Url32)'"
          "(^[$]checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
          "(^[$]checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
          "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
          "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      }
  }
}

function global:au_AfterUpdate {
  Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor all
