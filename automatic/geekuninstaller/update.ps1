Import-Module AU
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$releases = 'https://geekuninstaller.com/download'

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $re = '.zip'
  $url32 = 'https://geekuninstaller.com' + ($download_page.Links | Where-Object { $_.href -match $re } | Select-Object -First 1 -ExpandProperty href)

  #region getVers
  $fileName = Split-Path -Leaf $Url32
  $dest = "$env:TEMP\$fileName"
  $appFile = "$env:TEMP\geek.exe"

  Get-WebFile $Url32 $dest | Out-Null
  Expand-Archive -LiteralPath $dest -DestinationPath $env:TEMP
  $vers = (Get-Item $appFile).VersionInfo.FileVersion
  Remove-Item -Path $env:TEMP\geek*.*
  #endregion

  $version = $vers
  $ChecksumType = 'sha256'

  @{
    Url32            = $Url32
    Version          = $version
    ChecksumType32   = $ChecksumType
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

Update-Package -ChecksumFor none
