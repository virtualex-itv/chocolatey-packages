Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.binaryfortress.com/WindowInspector/Download/'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = 'Log='
  $url = $download_page.Links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href
  $url32 = Get-RedirectedUrl $url

  $re = 'Setup-|\.exe$'
  $version = ($url32 -split $re)[1]

  @{
    Url32            = $Url32
    Version          = $version
  }
}

function global:au_SearchReplace {
  @{ }
}

function global:au_AfterUpdate {
  Update-Metadata -key "dependency" -value "windowinspector.install|[$($Latest.Version)]"
}

Update-Package -ChecksumFor none
