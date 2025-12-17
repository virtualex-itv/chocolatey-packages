Import-Module Chocolatey-AU

$releases = 'https://www.powershellgallery.com/packages/VMware.PowerCLI'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '((\d+)\.(\d+)\.(\d+)\.(\d+))'
  $version = $download_page -match $re | Out-Null
  $version = $Matches[0]

  $releaseInfo = 'https://docs.vmware.com/en/VMware-PowerCLI/toc.json'
  $jsonFile = (Invoke-WebRequest -Uri $releaseInfo | ConvertFrom-Json)
  $re = "*Release Notes*"
  $docsUrl = "https://docs.vmware.com"
  $releaseNotesUrl = $jsonFile.children.children.children | Where-Object { $_.name -like $re } | Select-Object -First 1 -ExpandProperty link_url
  $releaseNotes = "$docsUrl$releaseNotesUrl"

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
