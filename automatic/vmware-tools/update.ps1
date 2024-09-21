Import-Module Chocolatey-AU

$releaseJson = "https://docs.vmware.com/en/VMware-Tools/toc.json"

function CreateStream {
  param ( $latest )

  #region Get VMware Tools for Windows Urls
  if ($mainVersion -notmatch '\.\d+\.\d+$') {
      $mainVersion += ".0"
  }

  $ReleaseNotes = "https://docs.vmware.com$($latest.link_url)"

  $buildInfo = Invoke-WebRequest -Uri $ReleaseNotes -UseBasicParsing
  $buildInfoContent = $buildInfo.RawContent -replace '&nbsp;', ' ' -replace '<[^>]+>', ''
  $buildNumber = if ($buildInfoContent -match 'Build No\s*(\d+)') { $Matches[1] } elseif ($buildInfoContent -match '\|\s*(\d{8})') { $Matches[1] }

  $version = "$($mainVersion).$($buildNumber)"

  $releaseUrl32 = "https://packages.vmware.com/tools/releases/$($mainVersion)/windows/x86/"
  $releaseUrl64 = "https://packages.vmware.com/tools/releases/$($mainVersion)/windows/x64/"

  $dlUrl32 = Invoke-WebRequest $releaseUrl32 -UseBasicParsing
  $dlUrl64 = Invoke-WebRequest $releaseUrl64 -UseBasicParsing

  $file32 = ($dlUrl32.Links | Where-Object { $_.href -like '*.exe' }).href
  $file64 = ($dlUrl64.Links | Where-Object { $_.href -like '*.exe' }).href

  $Url32 = "$($releaseUrl32)$($file32)"
  $Url64 = "$($releaseUrl64)$($file64)"
  #endregion

  $Result = @{
      Url32          = $Url32
      Url64          = $Url64
      Version        = $version
      ReleaseNotes   = $ReleaseNotes
  }
  return $Result
}

function global:au_GetLatest {
  $streams = @{}

  #region Get VMware Tools for Windows Versions
  $response = Invoke-WebRequest -Uri $releaseJson | ConvertFrom-Json

  foreach ( $product in $response.children.children) {
    $mainVersion = [regex]::Match($product.children.name, '\d+\.\d+(\.\d+)?').Value
    $majVersion = [regex]::Match($mainVersion, '^\d+').Value
    if (-not [string]::IsNullOrEmpty($mainVersion) -and $mainVersion -notlike '%.') {
      if (-not $streams.ContainsKey($majVersion) -or ([version]$mainVersion -gt [version]$streams[$majVersion].Version)) {
        $latest = $product.children[0]
        $streams.Add( $majVersion, (CreateStream $latest))
      }
    }
  }

  return @{ Streams = $streams }
  #endregion
}

function global:au_SearchReplace {
  @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"            = "`$1'$($Latest.Url32)'"
          "(^[$]checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
          "(^[$]checksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
          "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
          "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
          "(^[$]checksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
      }
  }
}

function global:au_AfterUpdate {
  Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor all
