# Fetches a page, retrying when the request fails or the content comes back without
# the expected marker. Vendor sites intermittently serve a page with no release list
# (or a 5xx), which otherwise surfaces as an opaque downstream error. Backoff is
# jittered so packages sharing a host in a parallel AU run do not retry in lockstep.
function Get-RetryWebResponse {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string] $Uri,
    [string] $MustMatch,
    [int]    $Retries = 4
  )
  $ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
  $waits = @(0, 3, 8, 20, 30)
  $last = $null
  for ($i = 1; $i -le $Retries; $i++) {
    if ($i -gt 1) {
      $w = $waits[[Math]::Min($i - 1, $waits.Count - 1)]
      Start-Sleep -Seconds ($w + (Get-Random -Minimum 0 -Maximum 3))
    }
    try {
      $r = Invoke-WebRequest -Uri $Uri -UseBasicParsing -UserAgent $ua
      if ($r.Content -and (-not $MustMatch -or $r.Content -match $MustMatch)) { return $r }
      $last = "content did not match '$MustMatch'"
    } catch { $last = $_.Exception.Message }
  }
  throw "Could not read expected content from $Uri after $Retries attempts ($last)"
}
