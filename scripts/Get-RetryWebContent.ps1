# Content-only wrapper around Get-RetryWebResponse.
function Get-RetryWebContent {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)][string] $Uri,
    [string] $MustMatch,
    [int]    $Retries = 4
  )
  (Get-RetryWebResponse @PSBoundParameters).Content
}
