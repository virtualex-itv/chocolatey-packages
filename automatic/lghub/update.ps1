Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$releases     = 'https://www.logitechg.com/en-us/software/ghub'
$releaseNotes = 'https://marketplace.logi.com/releasenotes/ghub/en'
$feedBase     = 'https://updates.ghub.logitechg.com/pipeline/v2/update/ghub13/win'

function GetChecksum([string]$Url32) {
  $fileName = Split-Path -Leaf $Url32
  $dest = "$env:TEMP\$fileName"

  Get-WebFile $Url32 $dest | Out-Null
  $checksum32 = Get-FileHash $dest -Algorithm sha256 | ForEach-Object Hash
  Remove-Item $dest -Force -ErrorAction SilentlyContinue

  @{
    Url32          = $Url32
    ChecksumType32 = 'sha256'
    Checksum32     = $checksum32
  }
}

function global:au_GetLatest {
  # Highest version offered by any of three sources: the release notes, and the updater's public and canary feeds.
  # The sources disagree for weeks at a time (Oct 2026: notes and canary 2026.7.992920, public 2026.6.981214, while the
  # app itself prompted for 2026.7.992920), so no single one is authoritative. Do NOT read the installer's ProductVersion:
  # it is a bootstrapper whose own version lags the app.
  $found = @()
  try {
    $notes = Get-RetryWebContent $releaseNotes -MustMatch '20\d\d\.\d+\.\d+'
    $found += [regex]::Matches($notes, '20\d\d\.\d+\.\d+') | ForEach-Object { [pscustomobject]@{ Source = 'release notes'; Version = $_.Value } }
  } catch { Write-Warning "G HUB release notes unavailable: $($_.Exception.Message)" }
  foreach ($channel in 'public', 'canary') {
    try {
      $v = (Invoke-RestMethod -Uri "$feedBase/$channel/update.json" -UseBasicParsing).version
      if ($v -match '^20\d\d\.\d+\.\d+$') { $found += [pscustomobject]@{ Source = "$channel feed"; Version = $v } }
    } catch { Write-Warning "G HUB $channel feed unavailable: $($_.Exception.Message)" }
  }
  if (-not $found) { throw 'Could not read a G HUB version from the release notes or either update feed' }
  $found | Group-Object Source | ForEach-Object { Write-Host ("  {0,-14} {1}" -f $_.Name, ($_.Group.Version | Sort-Object { [version]$_ } -Descending | Select-Object -First 1)) }
  $version = $found.Version | Sort-Object { [version]$_ } -Descending | Select-Object -First 1

  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $Url32 = $download_page.Links | Where-Object { $_.href -match '\.exe' } | Select-Object -First 1 -ExpandProperty href
  if (-not $Url32) { throw "Could not find an installer link on $releases" }

  $nuspecVersion = ([xml](Get-Content "$PSScriptRoot\lghub.nuspec")).package.metadata.version

  # Get ETag and Content-Length via HEAD request
  $request = [System.Net.WebRequest]::CreateDefault($Url32)
  $request.Method = "HEAD"
  try {
    $response = $request.GetResponse()
    $etag = $response.Headers.Get("ETag")
    $contentLength = $response.ContentLength.ToString()
  } finally {
    if ($response) { $response.Dispose() }
  }

  $saveFile = ".\info"
  $needsUpdate = $true

  # Re-hash when the CDN swaps the stub OR the nuspec is behind, so a version bump
  # never reaches au_SearchReplace without a matching checksum.
  if ((Test-Path $saveFile) -and !$global:au_Force) {
    $existingInfo = (Get-Content $saveFile -Encoding UTF8 -TotalCount 1) -split '\|'
    if ($existingInfo[0] -eq $etag -and $existingInfo.Count -gt 2 -and $existingInfo[2] -eq $contentLength -and [version]$nuspecVersion -ge [version]$version) {
      $needsUpdate = $false
      $result = @{ Url32 = $Url32; Version = $version }
    }
  }

  if ($needsUpdate) {
    $result = GetChecksum $Url32
    $result.Version = $version
    "$etag|$version|$contentLength" | Out-File $saveFile -Encoding utf8 -NoNewline

    # Logitech swapped the stub without a version bump: force a fix-version so the latest package keeps installing.
    $match = Select-String -Path "$PSScriptRoot\tools\chocolateyInstall.ps1" -Pattern '\$checksum\s*=\s*''([a-fA-F0-9]{64})''' -ErrorAction SilentlyContinue
    if ($match -and $match.Matches[0].Groups[1].Value -ne $result.Checksum32) {
      Write-Host "Checksum changed without version bump - forcing update"
      $global:au_Force = $true
    }
  }

  $result
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

Update-Package -ChecksumFor none -NoReadme
