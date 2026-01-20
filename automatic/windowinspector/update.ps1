Import-Module Chocolatey-AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://www.binaryfortress.com/WindowInspector/Download/'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = 'Log='
  $url = $download_page.Links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href
  $url32 = Get-RedirectedUrl $url

  # Extract version from URL like WindowInspectorSetup-3.8c.exe
  # Handles versions like 3.8, 3.8c, 3.10, 3.10a, etc.
  if ($url32 -match 'Setup-(\d+\.\d+)([a-z]?)\.exe$') {
    $version = $matches[1]
    # Convert letter suffix to patch number (a=1, b=2, c=3, etc.) or 0 if no suffix
    $suffix = $matches[2]
    if ($suffix) {
      $patch = [int][char]$suffix - [int][char]'a' + 1
    } else {
      $patch = 0
    }
    $version = "$version.$patch"
  } else {
    throw "Could not extract version from URL: $url32"
  }

  @{
    Url32            = $Url32
    Version          = $version
  }
}

function global:au_SearchReplace {
  @{
      "$($Latest.PackageName).nuspec" = @{
          "(\<dependency .+?`"$($Latest.PackageName).install`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
      }
    }
}

Update-Package -ChecksumFor none
