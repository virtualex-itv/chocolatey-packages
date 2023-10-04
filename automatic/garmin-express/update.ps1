import-module au

$url = 'https://download.garmin.com/omt/express/GarminExpress.exe'
$forumsticky = "https://support.garmin.com/en-US/?faq=9MuiEv9c2y2wgcXvzEVEe8"

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
    }
}

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $forumsticky -UseBasicParsing

    $regex = 'Current Version of Garmin Express for Windows:\s+(?<version>[\d\.]+)'
    if ($download_page.Content -match $regex) {
    $version = $Matches.version
    }

    @{
        URL32   = $url
        Version = $version
    }
}

Update-Package
