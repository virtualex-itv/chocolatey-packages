Import-Module AU

$releases = 'https://www.powershellgallery.com/packages/VMware.PowerCLI'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '((\d+)\.(\d+)\.(\d+)\.(\d+))'
  $version = $download_page -match $re | Out-Null
  $version = $Matches[0]

  $base_version = ($Matches[0] -split "$($Matches[5])").TrimEnd('.')[0]

  $code_url = "https://code.vmware.com/web/tool/$($base_version)/vmware-powercli"
  $docs = Invoke-WebRequest -Uri $code_url -UseBasicParsing

  $re = 'release-notes'
  $ReleaseNotes = "https://code.vmware.com$($docs.links.href -match $re)"

  @{
    Version           = $version
    ReleaseNotes      = $ReleaseNotes
  }
}

function global:au_SearchReplace {
  @{ }
}

function global:au_AfterUpdate {
Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor none
