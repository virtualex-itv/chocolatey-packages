Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$baseURL = "https://fdendpoint-tf-ae40cce298ca76ff-prod-a2bhbrbte7exh5d4.a01.azurefd.net/resources/prod/"
$jsFile = "$($baseURL)versionInfo.json"

function global:au_GetLatest {
    $jsContent = (Invoke-WebRequest -Uri $jsFile).Content | ConvertFrom-Json

    $version = $jsContent.version[0]
    $Url32 = "${baseURL}RVTools${version}.msi"

    @{
      Version           = $version
      Url32             = $Url32
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
