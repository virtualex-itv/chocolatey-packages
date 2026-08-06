Import-Module Chocolatey-AU

# Version + sha512 from Termius's electron-updater feed (what the app's own updater
# reads). Do NOT detect from the changelog - it publishes days before the stable rollout.
$feedUrl      = 'https://autoupdate.termius.com/windows/latest.yml'
$installerUrl = 'https://download.termius.com/windows/Install%20Termius.exe'

function global:au_GetLatest {
  $yaml = (Invoke-WebRequest -Uri $feedUrl -UseBasicParsing).Content
  if ($yaml -is [byte[]]) { $yaml = [System.Text.Encoding]::UTF8.GetString($yaml) }

  if ($yaml -notmatch '(?m)^version:\s*(\S+)\s*$') { throw "No version in $feedUrl" }
  $version = $Matches[1]

  # Anchored ^sha512 skips the indented per-file copy; base64 -> hex for Chocolatey.
  if ($yaml -notmatch '(?m)^sha512:\s*(\S+)\s*$') { throw "No sha512 in $feedUrl" }
  $checksum = ([BitConverter]::ToString([Convert]::FromBase64String($Matches[1])) -replace '-', '').ToLower()

  @{
    Url32            = $installerUrl
    Version          = $version
    ChecksumType32   = 'sha512'
    Checksum32       = $checksum
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
