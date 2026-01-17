Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.cyberpowersystems.com/product/software/power-panel-personal/powerpanel-personal-windows/'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '.exe'
  $Url32 = $download_page.Links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href
  $re = "v(\d+\.\d+\.\d+)"
  $version = [regex]::Match($Url32, $re).Groups[1].Value
  $ChecksumType = 'sha256'

  # Get release notes from salsify PDF links (second PDF is typically the release notes)
  $salsifyPdfs = $download_page.Links | Where-Object { $_.href -match 'salsify\.com.*\.pdf$' } | Select-Object -ExpandProperty href -Unique
  # Skip first PDF (EULA), take second one (Release Notes)
  $ReleaseNotes = $salsifyPdfs | Select-Object -Skip 1 -First 1
  $DocsUrl = $ReleaseNotes

  @{
    Url32             = $Url32
    Version           = $version
    ChecksumType32    = $ChecksumType
    ReleaseNotes      = $ReleaseNotes
    DocsUrl           = $DocsUrl
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

function global:au_AfterUpdate {
  if ($Latest.DocsUrl) { Update-Metadata -key "docsUrl" -value $Latest.DocsUrl }
  if ($Latest.ReleaseNotes) { Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes }
}

Update-Package -ChecksumFor none
