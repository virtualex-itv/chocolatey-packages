Import-Module Chocolatey-AU

$channel = 'https://pkgs.tailscale.com/stable/'

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(?i)(^\`$urlArm64\s*=\s*)'.*'"      = "`${1}'$($Latest.UrlArm64)'"
      "(?i)(^\`$checksumArm64\s*=\s*)'.*'" = "`${1}'$($Latest.ChecksumArm64)'"
      "(?i)(^\`$url32\s*=\s*)'.*'"         = "`${1}'$($Latest.Url32)'"
      "(?i)(^\`$checksum32\s*=\s*)'.*'"    = "`${1}'$($Latest.Checksum32)'"
      "(?i)(^\`$url64\s*=\s*)'.*'"         = "`${1}'$($Latest.Url64)'"
      "(?i)(^\`$checksum64\s*=\s*)'.*'"    = "`${1}'$($Latest.Checksum64)'"
    }
  }
}

function global:au_BeforeUpdate {
  $Latest.ChecksumArm64 = (Invoke-WebRequest -UseBasicParsing "$($Latest.UrlArm64).sha256").Content.Trim().Split(' ')[0]
  $Latest.Checksum32    = (Invoke-WebRequest -UseBasicParsing "$($Latest.Url32).sha256").Content.Trim().Split(' ')[0]
  $Latest.Checksum64    = (Invoke-WebRequest -UseBasicParsing "$($Latest.Url64).sha256").Content.Trim().Split(' ')[0]
}

function global:au_GetLatest {
  $meta = Invoke-RestMethod -Uri ($channel + '?mode=json&os=windows')
  $version = $meta.Version

  return @{
    Version   = $version
    UrlArm64  = $channel + $meta.MSIs.arm64
    Url32     = $channel + $meta.MSIs.x86
    Url64     = $channel + $meta.MSIs.amd64
  }
}

Update-Package -ChecksumFor none -NoReadme
