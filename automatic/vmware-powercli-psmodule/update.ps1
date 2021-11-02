Import-Module AU

$releases = 'https://www.powershellgallery.com/packages/VMware.PowerCLI'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '((\d+)\.(\d+)\.(\d+)\.(\d+))'
  $version = $download_page -match $re | Out-Null
  $version = $Matches[0]

  $releaseInfo = 'https://developer.vmware.com/docs/assets/powercli-release-info.json'
  $jsonFile = (Invoke-WebRequest -Uri $releaseInfo | ConvertFrom-Json) -split "`r`n" | Where-Object {$_}
  $re = 'https'
  $releaseNotesUrl = foreach ($line in $jsonFile) {($line.split('=| |;') | Where-Object {$_ -match $re})[0]}
  $releaseNotes = Get-RedirectedUrl $releaseNotesUrl

  @{
    Version           = $version
    ReleaseNotes      = $releaseNotes
  }
}

function global:au_SearchReplace {
  @{ }
}

function global:au_AfterUpdate {
Update-Metadata -key "releaseNotes" -value $Latest.ReleaseNotes
}

Update-Package -ChecksumFor none
