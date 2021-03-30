Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.robware.net/rvtools/download/'

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $string = '.msi'
    $Url32 = (($download_page.Content.ToString() -split "[`r`n]" | Select-String $string | Select-Object -First 1) -split '=|;')[1].trim()
    $Url32 = $url32.Replace("`"","")
    $version = Get-Version($Url32)
    $ChecksumType = 'sha256'

    @{
      Url32             = $Url32
      Version           = $version
      ChecksumType32    = $ChecksumType
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
