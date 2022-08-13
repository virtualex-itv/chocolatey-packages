Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://github.com/XhmikosR/jpegoptim-windows/releases/'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = "*win64*"
  $Url = 'https://github.com' + ($download_page.Links | Where-Object { $_.href -like $re } | Select-Object -First 1 -ExpandProperty href)

  $tag = ( ($Url).Split('-')[3] + '-' + ($Url).Split('-')[4] )
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
