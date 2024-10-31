Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$baseURL = "https://resources.robware.net/resources/prod/"
$jsonFile = "$($baseURL)manifest.json"

function global:au_GetLatest {
    $jsonContent = (Invoke-WebRequest -Uri $jsonFile -UseBasicParsing).Content

    if ($jsonContent[0] -eq 0xFF -and $jsonContent[1] -eq 0xFE) {
      $jsonContent = $jsonContent[2..($jsonContent.Length - 1)]
    }

    $jsonData = [System.Text.Encoding]::Unicode.GetString($jsonContent) | ConvertFrom-Json

    $version = $jsonData.version
    $Url32 = "$baseURL$($jsonData.Name)"
    $checksum = $jsonData.SHA256
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
