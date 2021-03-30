Import-Module AU

$releases = 'https://github.com/lensapp/lens/releases/latest'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '.*\.exe'
  $Url32 = $download_page.links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href

  $version = Get-Version($Url32)
  $ChecksumType = 'sha256'

  $ReleaseNotes = "https://github.com/lensapp/lens/releases/tag/v$($version)"

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

function global:au_AfterUpdate {
Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor 32
