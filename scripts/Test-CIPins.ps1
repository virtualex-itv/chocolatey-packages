<#
.SYNOPSIS
  Warns when a tool pinned in .appveyor.yml is behind the latest stable version on the community repository.
.DESCRIPTION
  Reads choco_version and the package pins from the install step. choco_version_pr is skipped on purpose:
  it is meant to stay at the minimum supported Chocolatey version. Never fails; it only prints warnings.
#>
param(
  [string]$File = (Join-Path $PSScriptRoot '..\.appveyor.yml')
)

$ErrorActionPreference = 'Continue'

function ConvertTo-SortableVersion([string]$Version) {
  ($Version -split '[.\-]' | ForEach-Object { if ($_ -match '^\d+$') { '{0:D10}' -f [int64]$_ } else { $_ } }) -join '.'
}

function Get-LatestStable([string]$Id) {
  $url = "https://community.chocolatey.org/api/v2/FindPackagesById()?id='$Id'"
  $xml = [xml](Invoke-WebRequest -Uri $url -UseBasicParsing -UserAgent 'Mozilla/5.0').Content
  $versions = foreach ($entry in $xml.feed.entry) {
    $p = $entry.properties
    if ($p.IsPrerelease.'#text' -eq 'false' -or $p.IsPrerelease -eq 'false') { [string]$p.Version }
  }
  $versions | Sort-Object { ConvertTo-SortableVersion $_ } | Select-Object -Last 1
}

$pins = [ordered]@{}
foreach ($line in Get-Content -LiteralPath $File) {
  if ($line -match "^\s+choco_version:\s*'([^']+)'") { $pins['chocolatey'] = $Matches[1] }
  elseif ($line -match "^\s+'([A-Za-z0-9.\-]+)'\s*=\s*'(\d[^']*)'") { $pins[$Matches[1]] = $Matches[2] }
}

$behind = 0
foreach ($id in $pins.Keys) {
  try { $latest = Get-LatestStable $id } catch { Write-Warning "Could not look up $id : $($_.Exception.Message)"; continue }
  if (-not $latest) { Write-Warning "No stable version found for $id"; continue }
  if ((ConvertTo-SortableVersion $latest) -gt (ConvertTo-SortableVersion $pins[$id])) {
    Write-Warning ("CI pin behind: {0} is {1}, latest is {2}" -f $id, $pins[$id], $latest)
    $behind++
  } else {
    Write-Host ("CI pin current: {0} {1}" -f $id, $pins[$id])
  }
}
Write-Host "$behind of $($pins.Count) CI pin(s) behind the latest stable version."
