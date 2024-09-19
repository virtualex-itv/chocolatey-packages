Import-Module Chocolatey-AU

$releases = 'https://softwareupdate.vmware.com/cds/vmw-desktop/vmrc/'

function global:au_GetLatest {
  #region Get Release Notes Url
  $releaseInfo = 'https://docs.vmware.com/en/VMware-Remote-Console/toc.json'
  $jsonFile = Invoke-WebRequest -Uri $releaseInfo | ConvertFrom-Json

  $re = "*Release Notes*"
  $docsUrl = "https://docs.vmware.com"
  $releaseNotesUrl = $jsonFile.children.children.children | Where-Object { $_.name -like $re } | Select-Object -First 1 -ExpandProperty link_url
  $releaseNotes = "$docsUrl$releaseNotesUrl"
  #endregion

  #region Get VMware Remote Console Url
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $versionFolder = $download_page.Links | Where-Object { $_.href -Match '(\d+)' } | Select-Object -Last 1 -ExpandProperty href
  $versionFolderUrl = $releases + $versionFolder

  $build_page = Invoke-WebRequest -Uri $versionFolderUrl -UseBasicParsing
  $buildFolder = $build_page.Links | Where-Object { $_.href -Match '(\d+)' } | Select-Object -Last 1 -ExpandProperty href
  $buildFolderUrl = $versionFolderUrl + $buildFolder

  $staticFolder = 'windows/'
  $fileFolderUrl = $buildFolderUrl + $staticFolder

  $re = '\.tar$'
  $file_page = Invoke-WebRequest -Uri $fileFolderUrl -UseBasicParsing
  $fileName = $file_page.Links | Where-Object { $_.href -match $re } | Select-Object -ExpandProperty href
  #endregion

  $Url32 = $fileFolderUrl + $fileName
  $version = ($versionFolder).Replace('/','.') + ($buildFolder).Trim('/')
  $ChecksumType = 'sha256'

  @{
    Url32             = $Url32
    Version           = $version
    ChecksumType32    = $ChecksumType
    ReleaseNotes      = $ReleaseNotes
  }
}

function global:au_BeforeUpdate() {
  $Latest.Checksum32 = Get-RemoteChecksum $Latest.Url32
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
