Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

$releases = 'https://www.logitechg.com/en-us/software/ghub'
$feedBase = 'https://updates.ghub.logitechg.com/pipeline/v2/update/ghub13/win'

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
  # Read without a logi-install-id header on purpose: that gets the public record, the build every machine has once its rollout ends.
  # The record's uuid is the content checksum, because the installer's own hash does not follow releases.
  $build = Invoke-RestMethod -Uri "$feedBase/public/details.json" -UseBasicParsing
  if ($build.version -notmatch '^20\d\d\.\d+\.\d+$' -or -not $build.uuid) { throw 'Unexpected details.json from the G HUB public channel' }
  Write-Host ("  public {0}  build {1}  uuid {2}..." -f $build.version, $build.buildId, $build.uuid.Substring(0, 8))
  $version = $build.version
  $uuid = $build.uuid

  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
  $Url32 = $download_page.Links | Where-Object { $_.href -match '\.exe' } | Select-Object -First 1 -ExpandProperty href
  if (-not $Url32) { throw "Could not find an installer link on $releases" }

  $nuspecVersion = ([xml](Get-Content "$PSScriptRoot\lghub.nuspec")).package.metadata.version

  # info = installer ETag | version | installer length | build uuid, as of the last package that was built
  $saveFile = ".\info"
  $existingInfo = @()
  if (Test-Path $saveFile) { $existingInfo = (Get-Content $saveFile -Encoding UTF8 -TotalCount 1) -split '\|' }
  $publishedUuid = if ($existingInfo.Count -gt 3) { $existingInfo[3] } else { $null }

  if ($publishedUuid) {
    $nuspecBase = ([version]$nuspecVersion).ToString(3)   # a fix-version package carries a 4th segment
    if ($publishedUuid -eq $uuid -and !$global:au_Force) {
      Write-Host '  Same build as the published package - nothing to package'
      $version = $nuspecVersion
    } elseif ([version]$version -lt [version]$nuspecBase) {
      Write-Warning "The public build ($version) is older than the published package ($nuspecVersion) - not downgrading"
      $version = $nuspecVersion
      $uuid = $publishedUuid   # so a later stub swap cannot record this older build as the published one
    } elseif ([version]$version -eq [version]$nuspecBase -and $publishedUuid -ne $uuid) {
      Write-Host 'Build replaced under the same version - forcing a fix-version update'
      $global:au_Force = $true
    }
  }

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

  $needsUpdate = $true

  # Re-hash when the CDN swaps the stub OR the nuspec is behind, so a version bump
  # never reaches au_SearchReplace without a matching checksum.
  if ($existingInfo.Count -gt 2 -and !$global:au_Force) {
    if ($existingInfo[0] -eq $etag -and $existingInfo[2] -eq $contentLength -and [version]$nuspecVersion -ge [version]$version) {
      $needsUpdate = $false
      $result = @{ Url32 = $Url32; Version = $version }
    }
  }

  if ($needsUpdate) {
    $result = GetChecksum $Url32
    $result.Version = $version
    "$etag|$version|$contentLength|$uuid" | Out-File $saveFile -Encoding utf8 -NoNewline

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
