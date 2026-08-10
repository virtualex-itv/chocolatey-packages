Import-Module Chocolatey-AU

# Version + sha512 + installer URL all come from Termius's electron-updater feed (what
# the app's own updater reads). The URL must be derived from the feed's own host: the
# canonical download.termius.com lags it during a rollout, so pairing that URL with the
# feed's hash yields a checksum mismatch.
# Do NOT detect from the changelog - it publishes days before the stable rollout.
$feedBase = 'https://autoupdate.termius.com/windows/'
$feedUrl  = "${feedBase}latest.yml"

function global:au_GetLatest {
  $yaml = (Invoke-WebRequest -Uri $feedUrl -UseBasicParsing).Content
  if ($yaml -is [byte[]]) { $yaml = [System.Text.Encoding]::UTF8.GetString($yaml) }

  if ($yaml -notmatch '(?m)^version:\s*(\S+)\s*$') { throw "No version in $feedUrl" }
  $version = $Matches[1]

  if ($yaml -notmatch '(?m)^path:\s*(.+?)\s*$') { throw "No path in $feedUrl" }
  $url32 = $feedBase + ($Matches[1] -replace ' ', '%20')

  # Anchored ^sha512 skips the indented per-file copy; base64 -> hex for Chocolatey.
  if ($yaml -notmatch '(?m)^sha512:\s*(\S+)\s*$') { throw "No sha512 in $feedUrl" }
  $checksum = ([BitConverter]::ToString([Convert]::FromBase64String($Matches[1])) -replace '-', '').ToLower()

  @{
    Url32            = $url32
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
