Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$releases = Get-GitHubRelease BetterDiscord Installer

function global:au_GetLatest {
  $Url = $releases.assets | Where-Object { $_.name.endswith('.exe') } | Select-Object -First 1 -ExpandProperty browser_download_url
  $version = $releases.tag_name.Trim('v')
  $ChecksumType = 'sha256'

  $tag = $releases.tag_name
  $ReleaseNotes = "https://github.com/BetterDiscord/Installer/releases/tag/$($tag)"

  @{
    Url32             = $Url
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
      'tools\VERIFICATION.txt' = @{
        "(?i)(32-Bit.+)\<.*\>"     = "`${1}<$($Latest.Url32)>"
      }
  }
}

function global:au_AfterUpdate {
Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor 32
