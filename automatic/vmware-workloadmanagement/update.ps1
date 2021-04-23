Import-Module AU

$releases = 'https://www.powershellgallery.com/packages/VMware.WorkloadManagement'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '((\d+)\.(\d+)\.(\d+))'
  $version = $download_page -match $re | Out-Null
  $version = $Matches[0]

  @{
    Version = $version
  }
}

function global:au_SearchReplace {
  @{ }
}

Update-Package -ChecksumFor none
