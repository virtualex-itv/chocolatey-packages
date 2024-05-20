Import-Module Chocolatey-AU

$releases = 'https://api.k8slens.dev/binaries/latest.json'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases | ConvertFrom-Json

  $constUrl = 'https://api.k8slens.dev/binaries/'
  $Url = "$($constUrl)$($download_page.path)"
  $Url32 = Get-RedirectedUrl $Url

  $version = ($download_page.version).Split('-')[0]
  $ChecksumType = 'sha256'

  $ReleaseNotes = "https://docs.k8slens.dev/main/release-notes/"

  @{
    Url32             = $Url32
    Version           = $version
    ChecksumType32    = $ChecksumType
    ReleaseNotes      = $ReleaseNotes
  }
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.Url32)'"
          "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
          "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      }
  }
}

Update-Package -ChecksumFor 32
