Import-Module Chocolatey-AU

# this url is now specifically for version 17.x.x due to docs site relocation to broadcom
$releaseJson = "https://techdocs.broadcom.com/bin/broadcom/techdocs2/TOCServlet?basePath=%2Fcontent%2Fbroadcom%2Ftechdocs%2Fus%2Fen%2Fvmware-cis%2Fdesktop-hypervisors%2Fworkstation-pro%2F17-0"

function CreateStream {
  param ( $latest )

  #region Get VMware Workstation Pro for Windows Urls
  $mainVersion = [regex]::Match($latest.title, '\d+\.\d+(\.\d+)?').Value
  if ($mainVersion -notmatch '\.\d+\.\d+$') {
    $mainVersion += ".0"
  }

  $ReleaseNotes = "https://techdocs.broadcom.com$($latest.link)"

  $buildInfo = Invoke-WebRequest -Uri $ReleaseNotes -UseBasicParsing
  $buildNumber = if (($buildInfo.RawContent -replace '&nbsp;', ' ' -replace '<[^>]+>', '') -match 'Build\s*(\d+)') { $Matches[1] }
  $version = "$($mainVersion).$($buildNumber)"

  $releaseUrl = "https://softwareupdate.vmware.com/cds/vmw-desktop/ws/$($mainVersion)/$($buildNumber)/windows/core"
  $dlUrl = Invoke-WebRequest $releaseUrl -UseBasicParsing
  $file32 = ($dlUrl.Links | Where-Object { $_.href -like '*.tar' }).href
  $Url32 = "$($releaseUrl)/$($file32)"
  #endregion

  $Result = @{
    Url32          = $Url32
    Version        = $version
    ReleaseNotes   = $ReleaseNotes
  }
  return $Result
}

function global:au_GetLatest {
  $streams = @{}

  #region Get VMware Workstation Pro for Windows Versions
  $response = Invoke-WebRequest -Uri $releaseJson | ConvertFrom-Json

  foreach ( $product in $response[0].children[0]) {
    $latest = $product
    $majVersion = [regex]::Match($product.title, '\d+').Value
    $streams.Add( $majVersion, (CreateStream $latest))
  }
  #endregion
  return @{ Streams = $streams }
}

function global:au_SearchReplace {
  return @{
      'tools\chocolateyInstall.ps1' = @{
          "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.Url32)'"
          "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
          "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
      }
  }
}

function global:au_AfterUpdate {
  Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor 32
