Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.robware.net/download'

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

    $jsReg = 'src="([^"]+\.js)"'
    $jsMatch = [regex]::Match($download_page.Content, $jsReg)
    $jsUrl = $jsMatch.Groups[1].Value
    $jsContent = (Invoke-WebRequest -Uri (($releases).Trim('/download') + $jsUrl) -UseBasicParsing).Content

    $re = 'RVTools([\d\.]+).msi'
    $Url32 = if ($jsContent -match $re) { (($releases).Replace('www.','')).Replace('download','resources/') + $Matches[0] }
    $version = $Matches[1]

    @{
      Url32             = $Url32
      Version           = $version
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
