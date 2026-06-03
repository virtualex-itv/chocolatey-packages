Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$history_page = 'https://www.stardock.com/products/multiplicity/history'

function global:au_GetLatest {
  $releases = Invoke-WebRequest -Uri $history_page -UseBasicParsing
  $content = $releases.Content

  # Get download URL from trial page (follows redirect to archive.stardock.com)
  $downloadPage = Invoke-WebRequest -Uri 'https://www.stardock.com/products/multiplicity/download-trial' -UseBasicParsing
  $null = $downloadPage.Content -match '(https?://[^\s"<>]+Multiplicity[^\s"<>]*\.exe)'
  $Url = $Matches[0]

  # Parse version from history page, skip betas
  $pattern = 'Multiplicity\s+(?<version>\d+\.\d+(?:\.\d+)*)(?<beta>\s+Beta)?'
  $versionMatches = [regex]::Matches($content, $pattern)
  $version = $null
  foreach ($m in $versionMatches) {
    if (-not $m.Groups['beta'].Success) {
        $version = $m.Groups['version'].Value
        break
    }
  }
  $ChecksumType = 'sha256'

  @{
    Url32             = $Url
    Version           = $version
    ChecksumType32    = $ChecksumType
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32 -Algorithm $Latest.ChecksumType32
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
