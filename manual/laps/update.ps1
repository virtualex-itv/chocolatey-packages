Import-Module Chocolatey-AU

$details_url = 'https://www.microsoft.com/en-us/download/details.aspx?id=46899'

# NOTE: Legacy Microsoft LAPS is deprecated as of Windows 11 23H2 and will not receive updates.
# This package is maintained for older systems only. New deployments should use Windows LAPS
# which is built into Windows (April 2023 updates and later).

function global:au_GetLatest {
  $page = Invoke-WebRequest -Uri $details_url -UseBasicParsing

  # Extract download URLs from page content (confirmation page no longer works)
  $Url32 = ([regex]::Match($page.Content, 'https://download\.microsoft\.com[^"''>\s]+LAPS\.x86\.msi')).Value
  $Url64 = ([regex]::Match($page.Content, 'https://download\.microsoft\.com[^"''>\s]+LAPS\.x64\.msi')).Value

  if (-not $Url32 -or -not $Url64) {
    throw "Could not find download URLs on the Microsoft download page"
  }

  # Version is static at 6.2 - legacy LAPS is deprecated and won't be updated
  # Using date suffix to track when we last verified the package
  $baseVersion = '6.2.0'
  $dateSuffix = Get-Date -Format 'yyyyMMdd'
  $version = "$baseVersion.$dateSuffix"

  @{
    Url32          = $Url32
    Url64          = $Url64
    Version        = $version
    ChecksumType32 = 'sha256'
    ChecksumType64 = 'sha256'
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32 -Algorithm $Latest.ChecksumType32
  $Latest.Checksum64 = Get-RemoteChecksum $Latest.Url64 -Algorithm $Latest.ChecksumType64
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.Url32)'"
          "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
          "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
          "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
          "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      }
  }
}

Update-Package -ChecksumFor none
