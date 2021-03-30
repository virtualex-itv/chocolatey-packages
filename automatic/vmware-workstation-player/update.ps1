Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://softwareupdate.vmware.com/cds/vmw-desktop/player/'

function global:au_GetLatest {
  #region Get VMware Workstation Player Url
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $versionFolder = $download_page.Links | Where-Object { $_.href -Match '(\d+)' } | Select-Object -Last 1 -Skip 2 -ExpandProperty href
  $versionFolderUrl = $releases + $versionFolder

  $build_page = Invoke-WebRequest -Uri $versionFolderUrl -UseBasicParsing
  $buildFolder = $build_page.Links | Where-Object { $_.href -Match '(\d+)' } | Select-Object -Last 1 -ExpandProperty href
  $buildFolderUrl = $versionFolderUrl + $buildFolder

  $staticFolders = 'windows/core/'
  $fileFolderUrl = $buildFolderUrl + $staticFolders

  $re = '\.tar$'
  $file_page = Invoke-WebRequest -Uri $fileFolderUrl -UseBasicParsing
  $fileName = $file_page.Links | Where-Object { $_.href -match $re } | Select-Object -ExpandProperty href

  $Url32 = $fileFolderUrl + $fileName
  $version = $versionFolder.Replace("/",".") + $buildFolder.Replace("/","")
  $ChecksumType = 'sha256'
  #endregion

  #region Get Release Notes Url
  $feed = 'https://docs.vmware.com/en/VMware-Workstation-Player/rn_rss.xml'
  $xml_fileName = Split-Path -Leaf $feed
  $dest = "$env:TEMP\vwp_$xml_fileName"

  Get-WebFile $feed $dest | Out-Null
  [xml]$content = Get-Content $dest

  $ReleaseNotes = $content.feed.entry | Where-Object { $_.id -Match $versionFolder } | Select-Object -ExpandProperty id

  Remove-Item $dest -Force -ErrorAction SilentlyContinue
  #endregion

  @{
    Url32          = $Url32
    Version        = $version
    ChecksumType32 = $ChecksumType
    ReleaseNotes   = $ReleaseNotes
  }
}

function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32 -Algorithm $Latest.ChecksumType32
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

function global:au_AfterUpdate {
  Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor none
