Import-Module Chocolatey-AU

<<<<<<< HEAD
$release = "https://techdocs.broadcom.com/us/en/vmware-cis/vsphere.html"

$response = Invoke-WebRequest -Uri $release -UseBasicParsing

$staticUrl = " https://techdocs.broadcom.com"
=======
$staticUrl = " https://techdocs.broadcom.com"

$release = "$($staticUrl)/us/en/vmware-cis/vsphere.html"

$response = Invoke-WebRequest -Uri $release -UseBasicParsing
>>>>>>> b8a6145eaf15505d634855fc16d404410e92b724

$toolsUrl = $staticUrl + ($response.Links | Where-Object { $_.href -match 'vsphere/tools' } | Select-Object -First 1 -ExpandProperty href)

$rootVersion = ($toolsUrl -split '/|.html')[-2]

$releaseJson = "https://techdocs.broadcom.com/bin/broadcom/techdocs2/TOCServlet?basePath=%2Fcontent%2Fbroadcom%2Ftechdocs%2Fus%2Fen%2Fvmware-cis%2Fvsphere%2Ftools%2F$($rootVersion)"

function CreateStream {
  param ( $latest )

  #region Get VMware Tools for Windows Urls
  if ($mainVersion -notmatch '^\d+\.\d+\.\d+$') {
    $mainVersion += ".0"
}

  $releaseNotes = $staticUrl + $latest.link

  $buildInfo = Invoke-WebRequest -Uri $releaseNotes -UseBasicParsing
  $buildInfoContent = $buildInfo.RawContent -replace '&nbsp;', ' ' -replace '<[^>]+>', ''
  $buildNumber = if ($buildInfoContent -match 'Build No\s*(\d+)') { $Matches[1] } elseif ($buildInfoContent -match '\|\s*(\d{8})') { $Matches[1] }

  $version = "$mainVersion.$buildNumber".TrimEnd('.')

  $releaseUrl64 = "https://packages.vmware.com/tools/releases/$($mainVersion)/windows/x64/"

  $dlUrl64 = Invoke-WebRequest $releaseUrl64 -UseBasicParsing

  $file64 = ($dlUrl64.Links | Where-Object { $_.href -like '*.exe' }).href

  $Url64 = "$($releaseUrl64)$($file64)"
  #endregion

  $Result = @{
      Url64          = $Url64
      Version        = $version
      ReleaseNotes   = $releaseNotes
  }
  return $Result
}

function global:au_GetLatest {
  $streams = @{}

  #region Get VMware Tools for Windows Versions
  $responseJson = Invoke-WebRequest -Uri $releaseJson -UseBasicParsing | ConvertFrom-Json

  foreach ( $product in $responseJson.children) {
    $mainVersion = [regex]::Match($product.title, '\d+(\.\d+)+').Value.TrimEnd('.')
    $majVersion = [regex]::Match($mainVersion, '^\d+').Value
    if (-not [string]::IsNullOrEmpty($mainVersion) -and $mainVersion -notlike '%.') {
      if (-not $streams.ContainsKey($majVersion) -or ([version]$mainVersion -gt [version]$streams[$majVersion].Version)) {
        $latest = $product[0]
        $streams.Add( $majVersion, (CreateStream $latest $mainVersion))
      }
    }
  }

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
