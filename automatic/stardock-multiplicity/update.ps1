Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$history_page = 'https://www.stardock.com/products/multiplicity/history'

function global:au_GetLatest {

  # Parse version from history page, skip betas
  $pattern = 'Multiplicity\s+(?<version>\d+\.\d+(?:\.\d+)*)(?<beta>\s+Beta)?'
  $content = Get-RetryWebContent $history_page -MustMatch $pattern

  # Download URL is scraped from the trial page
  $urlRe = '(https?://[^\s"<>]+Multiplicity[^\s"<>]*\.exe)'
  $null = (Get-RetryWebContent 'https://www.stardock.com/products/multiplicity/download-trial' -MustMatch $urlRe) -match $urlRe
  $Url = $Matches[0]
  $versionMatches = [regex]::Matches($content, $pattern)
  $version = $null
  foreach ($m in $versionMatches) {
    if (-not $m.Groups['beta'].Success) {
        $version = $m.Groups['version'].Value
        break
    }
  }

  # Normalize to match NuGet's on-disk nupkg filename so AU's GitReleases plugin can find it.
  $version = ConvertTo-NuGetVersion $version

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
