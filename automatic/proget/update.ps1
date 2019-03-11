import-module au

$releases = 'https://inedo.com/pg/update'

function global:au_BeforeUpdate {
    $Latest.Checksum32 = Get-RemoteChecksum $Latest.URL32 -Algorithm $Latest.ChecksumType32
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
    }
 }

function global:au_GetLatest {
    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
    
    $version = ([xml]($download_page.Content -replace "ï»¿")).proget.currentversion
    $version = Get-Version($version)

    $url = "https://inedo.com/files/proget/sql/" + $version

    $Latest = @{ URL32 = $url; Version = $version; ChecksumType32 = 'sha512' }
    return $Latest
}

if ($MyInvocation.InvocationName -ne '.') {
    update -ChecksumFor none
}