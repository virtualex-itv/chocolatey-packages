Import-Module Chocolatey-AU
Import-Module "$PSScriptRoot\..\..\scripts\au_extensions.psm1"

# Zoom's VDI download page is JS-rendered, so the version is read from the 'latest' MSI, downloaded only when its ETag or length changes.
$fileName  = 'ZoomVDIUniversalPluginx64.msi'
$latestUrl = "https://cdn.zoom.us/prod/vdi/x64/$fileName"

function Get-VersionedUrl([string]$Version) { "https://zoom.us/download/vdi/$Version/$fileName`?archType=x64" }

function Get-Head([string]$Url) {
  $request = [System.Net.HttpWebRequest]::Create($Url)
  $request.Method = 'HEAD'
  try {
    $response = $request.GetResponse()
    @{ ETag = $response.Headers['ETag']; Length = $response.ContentLength.ToString() }
  } finally {
    if ($response) { $response.Dispose() }
  }
}

# Reads one MSI property read-only (open mode 0); nothing is executed.
function Get-MsiProperty([string]$Path, [string]$Name) {
  $installer = New-Object -ComObject WindowsInstaller.Installer
  $db   = $installer.GetType().InvokeMember('OpenDatabase', 'InvokeMethod', $null, $installer, @($Path, 0))
  $view = $db.GetType().InvokeMember('OpenView', 'InvokeMethod', $null, $db, @("SELECT Value FROM Property WHERE Property = '$Name'"))
  $view.GetType().InvokeMember('Execute', 'InvokeMethod', $null, $view, $null) | Out-Null
  $record = $view.GetType().InvokeMember('Fetch', 'InvokeMethod', $null, $view, $null)
  $value  = if ($record) { $record.GetType().InvokeMember('StringData', 'GetProperty', $null, $record, 1) }
  $view.GetType().InvokeMember('Close', 'InvokeMethod', $null, $view, $null) | Out-Null
  foreach ($o in @($record, $view, $db, $installer)) { if ($o) { [void][Runtime.InteropServices.Marshal]::ReleaseComObject($o) } }
  [GC]::Collect(); [GC]::WaitForPendingFinalizers()
  $value
}

function global:au_GetLatest {
  $head     = Get-Head $latestUrl
  $saveFile = '.\info'

  # info = ETag|Version|Length|Checksum, so a cache hit still carries the checksum
  if ((Test-Path $saveFile) -and -not $global:au_Force) {
    $info = (Get-Content $saveFile -Encoding UTF8 -TotalCount 1) -split '\|'
    if ($info.Count -eq 4 -and $info[0] -eq $head.ETag -and $info[2] -eq $head.Length) {
      return @{ Version = $info[1]; URL64 = Get-VersionedUrl $info[1]; MsiChecksum = $info[3] }
    }
  }

  $dest = Join-Path $env:TEMP $fileName
  $ProgressPreference = 'SilentlyContinue'
  Invoke-WebRequest -UseBasicParsing $latestUrl -OutFile $dest

  # ARPCOMMENTS holds the full version, e.g. '7.0.14(27210)'; ProductVersion drops the patch number (7.0.27210)
  $comments = Get-MsiProperty $dest 'ARPCOMMENTS'
  if ($comments -notmatch '^(?<version>\d+\.\d+\.\d+)\((?<build>\d+)\)$') { throw "Unexpected ARPCOMMENTS '$comments' in $fileName" }
  $version  = "$($Matches['version']).$($Matches['build'])"
  $checksum = (Get-FileHash $dest -Algorithm SHA256).Hash.ToLower()
  Remove-Item $dest -Force

  # The package installs from the versioned URL, so it must serve the same file as 'latest'
  $versioned = Get-Head (Get-VersionedUrl $version)
  if ($versioned.ETag -ne $head.ETag) { throw "$(Get-VersionedUrl $version) serves ETag $($versioned.ETag), 'latest' serves $($head.ETag)" }

  "$($head.ETag)|$version|$($head.Length)|$checksum" | Out-File $saveFile -Encoding utf8 -NoNewline

  @{ Version = $version; URL64 = Get-VersionedUrl $version; MsiChecksum = $checksum }
}

function global:au_BeforeUpdate {
  $Latest.Checksum64 = $Latest.MsiChecksum
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$url64\s*=\s*)'.*'"      = "`${1}'$($Latest.URL64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum64)'"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
