Import-Module Chocolatey-AU

$indexUrl = 'https://packages-prod.broadcom.com/tools/releases/'

# Broadcom's index uses two different layouts:
#   - 12.x:        {version}/x64/VMware-tools-{version}-{build}-x64.exe
#   - 11.x, 13.x:  {version}/windows/x64/VMware-tools-{version}-{build}-x64.exe (or -x86_64.exe)
# Older 10.x releases dropped Windows installers from the latest patch levels, so
# we walk each major's version list from newest -> oldest until we find one with
# an x86_64 Windows installer.
function global:Find-WindowsExe {
  param([string]$version)
  foreach ($sub in @('x64', 'windows/x64')) {
    try {
      $url = "$indexUrl$version/$sub/"
      $r   = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
      $exe = ($r.Links | Where-Object { $_.href -match '-(x64|x86_64)\.exe$' } | Select-Object -First 1).href
      if ($exe) { return @{ Url = "$url$exe"; File = $exe } }
    } catch {}
  }
  return $null
}

function global:au_GetLatest {
  $r = Invoke-WebRequest -Uri $indexUrl -UseBasicParsing

  $allVersions = $r.Links |
    Where-Object { $_.href -match '^\d+\.\d+\.\d+/$' } |
    ForEach-Object { $_.href.TrimEnd('/') } |
    Sort-Object { [version]$_ } -Descending

  if (-not $allVersions) { throw 'No VMware Tools release entries found in package index.' }

  # Group versions by major, keeping them sorted newest-first
  $byMajor = [ordered]@{}
  foreach ($v in $allVersions) {
    $major = ([version]$v).Major.ToString()
    if (-not $byMajor.Contains($major)) { $byMajor[$major] = New-Object 'System.Collections.Generic.List[string]' }
    $byMajor[$major].Add($v)
  }

  $streams = @{}
  foreach ($major in $byMajor.Keys) {
    foreach ($ver in $byMajor[$major]) {
      $found = Find-WindowsExe -version $ver
      if (-not $found) { continue }

      $build = if ($found.File -match '-(\d+)-(?:x64|x86_64)\.exe$') { $Matches[1] } else { '0' }

      $streams[$major] = @{
        Version = "$ver.$build"
        Url64   = $found.Url
      }
      break
    }
  }

  return @{ Streams = $streams }
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyinstall.ps1' = @{
      "(^[$]url64\s*=\s*)('.*')"          = "`$1'$($Latest.Url64)'"
      "(^[$]checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(^[$]ChecksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"
    }
  }
}

function global:au_AfterUpdate {
  $v      = [version]($Latest.Version -replace '\.\d+$')  # strip build number -> X.Y.Z
  $folder = "$($v.Major)-$($v.Minor)-0"
  $slug   = "$($v.Major)$($v.Minor)$($v.Build)"
  $url    = "https://techdocs.broadcom.com/us/en/vmware-cis/vsphere/tools/$folder/release-notes/vmware-tools-$slug-release-notes.html"
  Update-Metadata -key 'releaseNotes' -value $url
}

Update-Package -ChecksumFor 64
