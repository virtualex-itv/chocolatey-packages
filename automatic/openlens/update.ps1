Import-Module AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$release = Get-GitHubRelease MuhammedKalkan OpenLens

function global:au_GetLatest {
  $Url = $release.assets | ? { $_.name.endswith('.exe') } | select -First 1 -ExpandProperty browser_download_url
  $version = $release.tag_name.Trim('v')
  if ($version -Match '-[alpha|beta].') {
    $number = "{0:d2}" -f [int]([regex]::Match($version,".(\d+)$")).Captures.Groups[1].value
    $version = $version -Replace ".(\d+)$", $number
  } elseif ($version -Match '-(\d+)') {
    $version = ($version).Replace('-','.')
  }
  $ChecksumType = 'sha256'

  $tag = $release.tag_name
  $ReleaseNotes = "https://github.com/MuhammedKalkan/OpenLens/releases/tag/$($tag)"

  @{
    Url64             = $Url
    Version           = $version
    ChecksumType64    = $ChecksumType
    ReleaseNotes      = $ReleaseNotes
  }
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
          "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      }
  }
}

function global:au_AfterUpdate {
Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor 64
