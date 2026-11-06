Import-Module Chocolatey-AU

# Version, package URL and SHA-256 all come from Google Update (Omaha), the service the
# installer stub and the app use. GeminiSetup.exe itself is a bootstrapper (156.x), so
# its file version says nothing about the app. No acceptformat is sent on purpose: that
# makes Google serve the plain NSIS exe instead of a CRX3-wrapped copy.
$updateUrl = 'https://update.googleapis.com/service/update2/json'
$appId     = '{533DD80C-942A-4464-B6A9-2E59428D784E}'

function global:au_GetLatest {
  # Google staged-rolls the answer per request (one query returns 1.17.0 or 1.18.0 at random), so ask several times and keep the highest.
  $check = $null
  foreach ($attempt in 1..12) {
    $request = @{
      request = @{
        protocol   = '3.1'
        '@os'      = 'win'
        '@updater' = 'gemini-desktop-au'
        sessionid  = "{$([guid]::NewGuid())}"
        requestid  = "{$([guid]::NewGuid())}"
        os         = @{ platform = 'win'; version = '10.0.26200'; arch = 'x64' }
        app        = @(@{ appid = $appId; version = '0.0.0.0'; ap = 'prod'; updatecheck = @{} })
      }
    } | ConvertTo-Json -Depth 6

    $raw = (Invoke-WebRequest -Uri $updateUrl -Method Post -Body $request -ContentType 'application/json' -UseBasicParsing).Content
    if ($raw -is [byte[]]) { $raw = [System.Text.Encoding]::UTF8.GetString($raw) }
    $answer = ($raw -replace "^\)\]\}'", '' | ConvertFrom-Json).response.app[0].updatecheck
    if ($answer.status -ne 'ok') { throw "Google Update returned '$($answer.status)' for Gemini" }
    if (-not $check -or [version]$answer.manifest.version -gt [version]$check.manifest.version) { $check = $answer }
  }

  $package = $check.manifest.packages.package | Where-Object { $_.required } | Select-Object -First 1
  $base    = $check.urls.url.codebase | Where-Object { $_ -like 'https://dl.google.com/*' } | Select-Object -First 1
  if (-not $base) { $base = $check.urls.url.codebase | Where-Object { $_ -like 'https://*' } | Select-Object -First 1 }
  if (-not $package -or -not $base) { throw 'Google Update response has no downloadable package' }
  if ($package.name -notlike '*.exe') { throw "Google Update served '$($package.name)', expected a plain .exe" }

  @{
    Version    = $check.manifest.version
    URL64      = $base + $package.name
    Checksum64 = $package.hash_sha256
  }
}

function global:au_SearchReplace {
  @{
    'tools\chocolateyInstall.ps1' = @{
      "(^\`$url64\s*=\s*)('.*')"      = "`${1}'$($Latest.URL64)'"
      "(^\`$checksum64\s*=\s*)('.*')" = "`${1}'$($Latest.Checksum64)'"
    }
  }
}

Update-Package -ChecksumFor none -NoReadme
