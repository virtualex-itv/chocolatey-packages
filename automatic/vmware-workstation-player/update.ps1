Import-Module Chocolatey-AU

$releaseJson = "https://docs.vmware.com/en/VMware-Workstation-Player/toc.json"

function CreateStream {
  param ( $latest )

  #region Get VMware Workstation Player for Windows Urls
  $mainVersion = [regex]::Match($latest.name, '\d+\.\d+(\.\d+)?').Value
  if ($mainVersion -notmatch '\.\d+\.\d+$') {
    $mainVersion += ".0"
  }

  $ReleaseNotes = "https://docs.vmware.com$($latest.link_url)"

  $buildInfo = Invoke-WebRequest -Uri $ReleaseNotes -UseBasicParsing
  $buildNumber = if (($buildInfo.RawContent -replace '&nbsp;', ' ' -replace '<[^>]+>', '') -match 'Build\s*(\d+)') { $Matches[1] }
  $version = "$($mainVersion).$($buildNumber)"

  $releaseUrl = "https://softwareupdate.vmware.com/cds/vmw-desktop/player/$($mainVersion)/$($buildNumber)/windows/core"
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

  #region Get VMware Workstation Player for Windows Versions
  $response = Invoke-WebRequest -Uri $releaseJson | ConvertFrom-Json

  foreach ( $product in $response.children[0].children) {
    $latest = $product.children[0]
    $majVersion = [regex]::Match($product.name, '\d+').Value
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
