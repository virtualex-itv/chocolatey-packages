$ErrorActionPreference = 'Stop'

$url = "Someurl"
$checksum = "abc"
$checksumType = "sha265"

$silentArgs = '/S /InstallSQLExpress'

$pp = Get-PackageParameters

$arguments = @{"Edition" = "Express"; "LogFile" = "$env:temp\proget_install.log" };

if(Test-Path 'hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ProGet') {
    $silentArgs += ' /Upgrade'
}

if($pp) {
    if($pp.ConnectionString) {
        $silentArgs = '/S'
    }

    $pp.Keys | % {
        $arguments.Set_Item(
            $_.Trim(),
            $pp.Item($_).Trim())
    }
}

$arguments.Keys | % {
    $silentArgs += ' "/' + $_ + '=' + $arguments[$_] + '"'
}

if($arguments.Edition -eq "Express" -or $arguments.Edition -eq "Trial") {
    if(!$arguments.EmailAddress -or !$arguments.FullName) {
        throw "When installing either an Express or Trial edition of ProGet, both EmailAddress and FullName properties must be provided.";
    }
}

if($arguments.Edition -eq "LicenseKey") {
    if(!arguments.LicenseKey) {
        throw "When installing a LicenseKey edition of ProGet, the LicenseKey property must be provided.";
    }
}

$packageArgs = @{
    packageName    = 'proget'
    filetype       = 'exe'
    url            = $url
    checksum       = $checksum
    checksumType   = $checksumType
    silentArgs     = $silentArgs
    validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs