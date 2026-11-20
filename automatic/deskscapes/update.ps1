Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$history_page = 'https://www.stardock.com/products/deskscapes/history'

function global:au_GetLatest {
  # Download URL is scraped from the trial page (it changes between major versions)
  $urlRe = '(https?://[^\s"<>]+DeskScapes[^\s"<>]*\.exe)'
  $null = (Get-RetryWebContent 'https://www.stardock.com/products/deskscapes/download-trial' -MustMatch $urlRe) -match $urlRe
  $Url = $Matches[0]

  # Match "DeskScapes 2026 v26.0.1.1", "DeskScapes 11.02" or "DeskScapes 11.0"
  $re = "DeskScapes(?: \d{4})? v?(?<version>\d+\.\d+(?:\.\d+)*)"
  $content = Get-RetryWebContent $history_page -MustMatch $re
  $null = $content -match $re
  $version = $Matches.version

  # Match NuGet's nupkg filename so GitReleases can find it (26.0.1.0 -> 26.0.1).
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

Update-Package -ChecksumFor none -NoReadme
