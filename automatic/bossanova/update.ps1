Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

function global:au_GetLatest {
  # The vendor's release feed carries the version and installer SHA-256 as base64 JSON in 'payload'.
  $feed = Invoke-RestMethod -Uri 'https://bsnv.app/releases/windows-x64/latest.json'
  $info = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($feed.payload)) | ConvertFrom-Json

  if ($info.product -ne 'Bossanova' -or $info.target -ne 'windows-x64') { throw "Unexpected release feed: $($info.product) / $($info.target)" }
  if ($info.version -notmatch '^\d+\.\d+\.\d+$') { throw "Unexpected version '$($info.version)' in the release feed" }
  if ($info.sha256 -notmatch '^[0-9a-fA-F]{64}$') { throw "Unexpected checksum '$($info.sha256)' in the release feed" }

  @{
    Version    = $info.version
    URL64      = "https://bsnv.app/releases/windows-x64/$($info.version)/Bossanova-Setup.exe"
    Checksum64 = $info.sha256.ToLower()
  }
}

function global:au_BeforeUpdate {
  # The feed says what the installer should hash to; confirm the file at the URL really does.
  $actual = Get-RemoteChecksum $Latest.URL64 -Algorithm 'sha256'
  if ($actual -ne $Latest.Checksum64) { throw "Installer checksum $actual does not match the release feed's $($Latest.Checksum64)" }
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
