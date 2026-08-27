Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$history_page = 'https://www.stardock.com/products/start11/history'

function global:au_GetLatest {
  $Url = 'https://cdn.stardock.us/downloads/public/software/start/v2/Start11v2-setup.exe'
  $pattern = 'Start11 v?(?<version>\d+(\.\d+)+)(?<beta> Beta)?'

  $content = Get-RetryWebContent $history_page -MustMatch $pattern
  $version = $null
  foreach ($m in [regex]::Matches($content, $pattern)) {
    if (-not $m.Groups['beta'].Success) { $version = $m.Groups['version'].Value; break }
  }
  if (-not $version) { throw "Could not find a non-beta Start11 version on $history_page" }

  # Match NuGet's nupkg filename so GitReleases can find it (2.74 -> 2.74.0).
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
