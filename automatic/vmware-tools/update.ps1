Import-Module Chocolatey-AU

$indexUrl = 'https://packages-prod.broadcom.com/tools/releases/'

function global:au_GetLatest {
  $r = Invoke-WebRequest -Uri $indexUrl -UseBasicParsing

  $allVersions = $r.Links |
    Where-Object { $_.href -match '^\d+\.\d+\.\d+/$' } |
    ForEach-Object { $_.href.TrimEnd('/') } |
    Sort-Object { [version]$_ } -Descending

  if (-not $allVersions) { throw 'No VMware Tools release entries found in package index.' }

  # Group by major version, pick newest of each
  $byMajor = @{}
  foreach ($v in $allVersions) {
    $major = ([version]$v).Major.ToString()
    if (-not $byMajor.ContainsKey($major)) { $byMajor[$major] = $v }
  }

  $streams = @{}
  foreach ($major in $byMajor.Keys) {
    $ver    = $byMajor[$major]
    $x64r   = Invoke-WebRequest -Uri "$indexUrl$ver/x64/" -UseBasicParsing
    $file64 = ($x64r.Links | Where-Object { $_.href -like '*.exe' } | Select-Object -First 1).href
    if (-not $file64) { continue }

    $build = if ($file64 -match '-(\d+)-x64\.exe') { $Matches[1] } else { '0' }

    $streams[$major] = @{
      Version = "$ver.$build"
      Url64   = "$indexUrl$ver/x64/$file64"
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
