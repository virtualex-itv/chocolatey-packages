Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://api.github.com/repos/XhmikosR/jpegoptim-windows/releases'

function global:au_GetLatest {
  $header = @{
    "Authorization" = "token $env:github_api_key"
  }

  $json = Invoke-WebRequest -Uri $releases -Headers $header | ConvertFrom-Json

  $Url = ($json.assets.browser_download_url)[0]

  $tag = ($json.tag_name)[0]
  $ReleaseNotes = "https://github.com/XhmikosR/jpegoptim-windows/releases/tag/$($tag)"

  $version = ( ($tag).Split('-')[0] + '.' + (($tag).Split('-')[1]).Split('l')[1] )
  $ChecksumType = 'sha256'

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
