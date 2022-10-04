Import-Module AU

$releases = 'https://api.github.com/repos/MuhammedKalkan/OpenLens/releases'

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }

  $response = Invoke-WebRequest -Uri $releases -Headers $header | ConvertFrom-Json

  $Url = ($response.assets.browser_download_url -match '.exe' -notmatch '.sha256')[0]
  $version = (($Url).Split('-') -split '.exe')[1]
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
