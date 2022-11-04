Import-Module AU
Import-Module "$PSScriptRoot\..\..\scripts/au_extensions.psm1"

$release = Get-GitHubRelease XhmikosR jpegoptim-windows

function global:au_GetLatest {
  $Url = $release.assets | ? { $_.name.endswith('.zip') } | select -First 1 -ExpandProperty browser_download_url
  $tag = $release.tag_name
  $version = ( ($tag).Split('-')[0] + '.' + (($tag).Split('-')[1]).Split('l')[1] )
  $ChecksumType = 'sha256'
  $ReleaseNotes = $release.html_url

  @{
    Url64             = $Url
    Version           = $version
    ChecksumType64    = $ChecksumType
    ReleaseNotes      = $ReleaseNotes
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64 -Algorithm $Latest.ChecksumType64
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
          "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      }
      'tools\VERIFICATION.txt' = @{
        "(?i)(64-Bit.+)\<.*\>"     = "`${1}<$($Latest.Url64)>"
      }
  }
}

function global:au_AfterUpdate {
  Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor none
