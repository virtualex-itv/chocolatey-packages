# Fetches a page, retrying when the request fails or the content comes back without
# the expected marker. Vendor sites (Stardock especially) intermittently serve a page
# with no release list, which otherwise surfaces as an opaque downstream error.
function Get-RetryWebContent {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string] $Uri,
    [string] $MustMatch,
    [int]    $Retries = 3
  )
  $ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'
  for ($i = 1; $i -le $Retries; $i++) {
    if ($i -gt 1) { Start-Sleep -Seconds ($i * 3) }
    try {
      $content = (Invoke-WebRequest -Uri $Uri -UseBasicParsing -UserAgent $ua).Content
      if ($content -and (-not $MustMatch -or $content -match $MustMatch)) { return $content }
    } catch { }
  }
  throw "Could not read expected content from $Uri after $Retries attempts"
}
