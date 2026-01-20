Import-Module Chocolatey-AU

$staticUrl = "https://techdocs.broadcom.com"

$release = "$($staticUrl)/us/en/vmware-cis/vsphere.html"

$response = Invoke-WebRequest -Uri $release -UseBasicParsing

$toolsUrl = $staticUrl + ($response.Links | Where-Object { $_.href -match 'vsphere/tools' } | Select-Object -First 1 -ExpandProperty href)

$rootVersion = ($toolsUrl -split '/|\.html')[-2]

$releaseJson = "$($staticUrl)/bin/broadcom/techdocs2/TOCServlet?basePath=%2Fcontent%2Fbroadcom%2Ftechdocs%2Fus%2Fen%2Fvmware-cis%2Fvsphere%2Ftools%2F$($rootVersion)"

function Normalize-MainVersion {
  param([string]$s)
  $m = [regex]::Match($s, '\d+(?:\.\d+)+').Value.Trim('.')
  if (-not $m) { return $null }
  $parts = $m.Split('.')
  if ($parts.Count -eq 2)    { return "$m.0.0" }   # 13.0    -> 13.0.0.0
  elseif ($parts.Count -eq 3){ return "$m.0"   }   # 13.0.0  -> 13.0.0.0
  else                       { return $m      }    # already 4 segments (e.g., 13.0.0.0)
}

function Trim-TrailingDotZero {
  param([string]$s)
  return ($s -replace '\.0$','')                  # 13.0.0.0 -> 13.0.0
}

function CreateStream {
  param (
    $latest,
    [string]$MainVersionNorm
  )

  #region Get VMware Tools for Windows Urls
  $releaseNotes = $staticUrl + $latest.link

  $buildInfo = Invoke-WebRequest -Uri $releaseNotes -UseBasicParsing
  $buildInfoContent = $buildInfo.RawContent -replace '&nbsp;', ' ' -replace '<[^>]+>', ''
  $buildNumber = if ($buildInfoContent -match 'Build No\s*(\d+)') { $Matches[1] } elseif ($buildInfoContent -match '\|\s*(\d{8})') { $Matches[1] }

  $displayMain = Trim-TrailingDotZero $MainVersionNorm
  $version = ("$displayMain.$buildNumber").TrimEnd('.')

  $releaseUrl64Base = "https://packages-prod.broadcom.com/tools/releases/$($displayMain)"

  # Try with /windows/ first (old structure), fall back to without (new structure)
  $releaseUrl64 = "$releaseUrl64Base/windows/x64/"
  $dlUrl64 = Invoke-WebRequest $releaseUrl64 -UseBasicParsing
  $file64 = ($dlUrl64.Links | Where-Object { $_.href -like '*.exe' }).href

  if (-not $file64) {
    $releaseUrl64 = "$releaseUrl64Base/x64/"
    $dlUrl64 = Invoke-WebRequest $releaseUrl64 -UseBasicParsing
    $file64 = ($dlUrl64.Links | Where-Object { $_.href -like '*.exe' }).href
  }

  $Url64 = "$($releaseUrl64)$($file64)"
  #endregion

  $Result = @{
      Url64           = $Url64
      Version         = $version
      ReleaseNotes    = $releaseNotes
  }
  return $Result
}

function global:au_GetLatest {
  $streams = @{}

  #region Get VMware Tools for Windows Versions
  $responseJson = Invoke-WebRequest -Uri $releaseJson -UseBasicParsing | ConvertFrom-Json

  # Flatten children defensively
  $children = @()
  if ($responseJson.children) { $children += $responseJson.children }
  if ($responseJson.children.children) { $children += $responseJson.children.children }

  # Filter to release-note entries and pick newest main version
  $bestProduct = $null
  $bestMain    = $null
  foreach ( $product in $children ) {
    if (-not ($product.title -match 'VMware Tools\s+\d')) { continue }
    $mainVersion = Normalize-MainVersion $product.title
    if (-not $mainVersion) { continue }

    if ($null -eq $bestMain -or ([version]$mainVersion -gt [version]$bestMain)) {
      $bestMain    = $mainVersion
      $bestProduct = $product
    }
  }

  if ($null -eq $bestProduct) {
    throw "No VMware Tools release entries found in TOC."
  }

  # Key by major stream (e.g., '13'); change to minor ('13.0') if you prefer.
  $majVersion = ([regex]::Match($bestMain, '^\d+').Value)
  $streams[$majVersion] = CreateStream -latest $bestProduct -MainVersionNorm $bestMain

  return @{ Streams = $streams }
  #endregion
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
          "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      }
  }
}

function global:au_AfterUpdate {
  Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor 64
