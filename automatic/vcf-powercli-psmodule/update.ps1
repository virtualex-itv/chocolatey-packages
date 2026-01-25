Import-Module Chocolatey-AU

$releases = 'https://www.powershellgallery.com/packages/VCF.PowerCLI'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '((\d+)\.(\d+)\.(\d+)\.(\d+))'
  $download_page.Content -match $re | Out-Null
  $version = $Matches[0]

  @{
    Version = $version
  }
}

function global:au_SearchReplace {
  @{ }
}

Update-Package -ChecksumFor none
