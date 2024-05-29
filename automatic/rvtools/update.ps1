Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$baseURL = "https://resources.robware.net/resources/prod/"
$jsFile = "$($baseURL)versions_manifest.json"

function global:au_GetLatest {
    $jsContent = (Invoke-WebRequest -Uri $jsFile).Content | ConvertFrom-Json

    $version = $jsContent.version
    $Url32 = "$baseURL$($jsContent.Name)"
    $checksum = $jsContent.SHA256
    $checksumType = "sha256"

    @{
      Version           = $version
      Url32             = $Url32
      Checksum32        = $checksum
      ChecksumType32    = $checksumType
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

Update-Package -ChecksumFor none
