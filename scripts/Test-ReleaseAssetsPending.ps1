function Test-ReleaseAssetsPending {
  <#
    .SYNOPSIS
      True when a GitHub release is recent enough that a missing asset is probably still being uploaded.

    .DESCRIPTION
      Projects often create the release before their CI attaches the installers. In au_GetLatest, when an
      expected asset is missing, call this and return 'ignore' if it is true, so the package is retried on
      the next run instead of failing the build. Otherwise throw: an old release without the asset means
      upstream renamed it, which should fail loudly.

    .EXAMPLE
      if (-not $asset) { if (Test-ReleaseAssetsPending $release) { return 'ignore' }; throw "No asset ..." }
  #>
  [CmdletBinding()]
  param(
    # A release object from Get-GitHubRelease
    [Parameter(Mandatory, Position = 0)]
    $Release,

    # How long after publishing a missing asset is still treated as "not uploaded yet"
    [int]$Hours = 72
  )

  $published = $Release.published_at
  if (-not $published) { return $false }

  $utc = if ($published -is [datetime]) { $published.ToUniversalTime() }
         else { [datetimeoffset]::Parse([string]$published, [Globalization.CultureInfo]::InvariantCulture, [Globalization.DateTimeStyles]::AssumeUniversal).UtcDateTime }
  $age = [datetime]::UtcNow - $utc
  if ($age.TotalHours -gt $Hours) { return $false }

  Write-Warning ("Release {0} was published {1:N1} hours ago and an expected asset is missing; the assets are probably still being uploaded, so this package is skipped until the next run." -f $Release.tag_name, $age.TotalHours)
  return $true
}
