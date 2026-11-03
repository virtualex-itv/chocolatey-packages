Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function global:au_GetLatest {
  # The feed `npm install cypress` itself reads to pick the binary, so it tracks what Cypress ships
  $feed = Invoke-RestMethod -Uri 'https://download.cypress.io/desktop.json' -UseBasicParsing
  $version = [string]$feed.version
  $url64 = [string]$feed.packages.'win32-x64'.url
  if ($version -notmatch '^\d+\.\d+\.\d+$') { throw "Unrecognized Cypress version in desktop.json: '$version'" }
  if ($url64 -notmatch '^https://cdn\.cypress\.io/.+/win32-x64/cypress\.zip$') { throw "Unrecognized win32-x64 URL in desktop.json: '$url64'" }

  @{
    Version      = $version
    URL64        = $url64
    ReleaseNotes = "https://github.com/cypress-io/cypress/releases/tag/v$version"
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = Get-RemoteChecksum $Latest.URL64 -Algorithm 'sha256'
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
    'cypress.nuspec' = @{
      '(<releaseNotes>)[^<]*(</releaseNotes>)' = "`${1}$($Latest.ReleaseNotes)`${2}"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
