# Normalizes a version string the same way NuGet does when writing a .nupkg filename:
# - Each numeric segment is parsed as an integer (drops leading zeros: '07' -> '7').
# - The version is padded with '.0' to at least 3 segments.
#
# Use this in au_GetLatest so the version AU stores as RemoteVersion matches the .nupkg
# filename on disk. The GitReleases plugin resolves the file with $Name.$RemoteVersion.nupkg
# and silently skips the GitHub release when the names don't match.
#
# Pure-numeric versions only. Any non-numeric segment (e.g. prerelease suffix) is returned
# unchanged so callers using SemVer-style versions aren't affected.
function ConvertTo-NuGetVersion {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [string] $Version
  )
  process {
    if (-not $Version) { return $Version }
    $parts = $Version.Split('.')
    if ($parts | Where-Object { $_ -notmatch '^\d+$' }) { return $Version }
    $ints = $parts | ForEach-Object { [int]$_ }
    while ($ints.Count -lt 3) { $ints += 0 }
    ($ints -join '.')
  }
}
