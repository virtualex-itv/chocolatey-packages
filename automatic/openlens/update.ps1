Import-Module AU

$releases = 'https://github.com/MuhammedKalkan/OpenLens/releases'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $Url = "https://github.com" + ($download_page.Links.href -match '.exe' -notmatch '.sha256')
  $version = (($Url).split('-') -split '.exe')[1]
  $ChecksumType = 'sha256'

  $ReleaseNotes = "https://github.com/lensapp/lens/releases/tag/v$($version)"

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
