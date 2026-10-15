<#
.SYNOPSIS
  Checks changed files for encoding and line-ending problems that have broken packages before.
.DESCRIPTION
  By default checks the files changed since the branch diverged from -DiffAgainst. Use -All for every
  tracked file or -Path for specific files.
  Errors:   BEL bytes; mixed line endings in the git index; PowerShell syntax errors; malformed nuspec XML;
            non-ASCII characters in a .ps1/.psm1 file without a BOM; a BOM in a README.md; a README.md
            that does not end with exactly one newline.
  Warnings: non-ASCII characters in a .ps1/.psm1 file that has a BOM.
.PARAMETER FailOnError
  Throws when any error was found (used by the PR build).
#>
param(
  [string]$DiffAgainst = 'origin/master',
  [switch]$All,
  [string[]]$Path,
  [switch]$FailOnError
)

$ErrorActionPreference = 'Stop'
$errors   = New-Object System.Collections.ArrayList
$warnings = New-Object System.Collections.ArrayList

function Add-Finding([string]$Level, [string]$File, [string]$Message) {
  $line = '{0}: {1} - {2}' -f $Level, $File, $Message
  if ($Level -eq 'ERROR') { [void]$errors.Add($line) } else { [void]$warnings.Add($line) }
  Write-Host $line
}

if ($Path) { $files = $Path }
elseif ($All) { $files = git ls-files }
else { $files = git diff "$DiffAgainst..." --name-only --diff-filter=d }

# Line-ending state of each file in the git index (lf, crlf, mixed, none)
$indexEol = @{}
git ls-files --eol | ForEach-Object {
  if ($_ -match '^i/(\S+)\s+w/\S+\s+attr/.*?\t(.+)$') { $indexEol[$Matches[2]] = $Matches[1] }
}

$textExtensions = '.ps1', '.psm1', '.ahk', '.nuspec', '.md', '.yml', '.json'
$checked = 0

foreach ($file in $files) {
  if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
    if ($Path) { Add-Finding 'ERROR' $file 'path not found' }
    continue
  }
  $ext = [System.IO.Path]::GetExtension($file).ToLower()
  if ($textExtensions -notcontains $ext) { continue }
  $checked++

  $bytes  = [System.IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $file).Path)
  $hasBom = ($bytes.Length -ge 3) -and ($bytes[0] -eq 0xEF) -and ($bytes[1] -eq 0xBB) -and ($bytes[2] -eq 0xBF)
  $text   = [System.Text.Encoding]::UTF8.GetString($bytes)
  if ($hasBom) { $text = $text.Substring(1) }

  if ($bytes -contains 7) { Add-Finding 'ERROR' $file 'contains a BEL (0x07) byte, usually a mangled backslash escape' }
  if ($indexEol[$file] -eq 'mixed') { Add-Finding 'ERROR' $file 'has mixed line endings in the git index' }

  $nonAscii = $text.ToCharArray() | Where-Object { [int]$_ -gt 127 } | Select-Object -First 1
  if ($nonAscii -and ($ext -eq '.ps1' -or $ext -eq '.psm1')) {
    if ($hasBom) { Add-Finding 'WARNING' $file 'contains non-ASCII characters' }
    else { Add-Finding 'ERROR' $file 'contains non-ASCII characters but has no BOM, so Windows PowerShell 5.1 misreads it' }
  }

  if ($ext -eq '.ps1' -or $ext -eq '.psm1') {
    $parseErrors = $null
    [void][System.Management.Automation.Language.Parser]::ParseInput($text, [ref]$null, [ref]$parseErrors)
    if ($parseErrors) { Add-Finding 'ERROR' $file ("syntax error: {0} (line {1})" -f $parseErrors[0].Message, $parseErrors[0].Extent.StartLineNumber) }
  }

  if ($ext -eq '.nuspec') {
    try { [void][xml]$text } catch { Add-Finding 'ERROR' $file ("malformed XML: {0}" -f $_.Exception.Message) }
  }

  if ([System.IO.Path]::GetFileName($file) -eq 'README.md') {
    if ($hasBom) { Add-Finding 'ERROR' $file 'has a BOM (Markdown is plain UTF-8)' }
    if ($text -notmatch "[^\r\n](\r?\n)\z") { Add-Finding 'ERROR' $file 'must end with exactly one newline' }
  }
}

Write-Host ("Repo hygiene: {0} file(s) checked, {1} error(s), {2} warning(s)." -f $checked, $errors.Count, $warnings.Count)
if ($FailOnError -and $errors.Count -gt 0) { throw "Repo hygiene check failed with $($errors.Count) error(s)." }
