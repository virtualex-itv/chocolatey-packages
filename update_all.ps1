# AU Packages Template: https://github.com/majkinetor/au-packages-template

param([string[]] $Name, [string] $ForcedPackages, [string] $Root = "$PSScriptRoot\automatic")

if (Test-Path $PSScriptRoot/update_vars.ps1) { . $PSScriptRoot/update_vars.ps1 }

$Options = [ordered]@{
    WhatIf        = $au_WhatIf                              #Whatif all packages
    Force         = $false                                  #Force all packages
    Timeout       = 100                                     #Connection timeout in seconds
    UpdateTimeout = 1200                                    #Update timeout in seconds
    Threads       = 10                                      #Number of background jobs to use
    Push          = $Env:au_Push -eq 'true'                 #Push to chocolatey
    PushAll       = $true                                   #Allow to push multiple packages at once
    PluginPath    = "$PSScriptRoot\scripts\plugins"          #Path to user plugins
    IgnoreOn      = @(                                      #Error message parts to set the package ignore status
      'Could not create SSL/TLS secure channel'
      'Could not establish trust relationship'
      'The operation has timed out'
      'Internal Server Error'
      'Service Temporarily Unavailable'
      'The connection was closed unexpectedly.'
      'package version already exists'
      'already exists on a Simple OData Server'             # https://github.com/chocolatey/chocolatey.org/issues/613
      'Conflict'
      'A system shutdown has already been scheduled'        # https://gist.github.com/choco-bot/a14b1e5bfaf70839b338eb1ab7f8226f#wps-office-free
    )
    RepeatOn      = @(                                      #Error message parts on which to repeat package updater
      'Could not create SSL/TLS secure channel'             # https://github.com/chocolatey/chocolatey-coreteampackages/issues/718
      'Could not establish trust relationship'              # -||-
      'Unable to connect'
      'The remote name could not be resolved'
      'Choco pack failed with exit code 1'                  # https://github.com/chocolatey/chocolatey-coreteampackages/issues/721
      'The operation has timed out'
      'Internal Server Error'
      'An exception occurred during a WebClient request'
      'remote session failed with an unexpected state'
      'The connection was closed unexpectedly.'
    )
    #RepeatSleep   = 250                                    #How much to sleep between repeats in seconds, by default 0
    #RepeatCount   = 2                                      #How many times to repeat on errors, by default 1

    Report = @{
        Type = 'markdown'                                   #Report type: markdown or text
        Path = "$PSScriptRoot\Update-AUPackages.md"         #Path where to save the report
        Params= @{                                          #Report parameters:
            Github_UserRepo = $Env:github_user_repo         #  Markdown: shows user info in upper right corner
            NoAppVeyor  = $false                            #  Markdown: do not show AppVeyor build shield
            UserMessage = "[Ignored](#ignored) | [History](#update-history) | [Force Test](https://gist.github.com/$Env:gist_id_test) | [Releases](https://github.com/$Env:github_user_repo/tags) | **TESTING AU NEXT VERSION**"       #  Markdown, Text: Custom user message to show
            NoIcons     = $false                            #  Markdown: don't show icon[Releases](https://github.com/$Env:github_user_repo/tags)
            IconSize    = 32                                #  Markdown: icon size
            Title       = ''                                #  Markdown, Text: TItle of the report, by default 'Update-AUPackages'
        }
    }

    # History plugin disabled - using custom script after updateall to fix "Parameter name: length" error
    # History = @{
    #     Lines = 120                                         #Number of lines to show
    #     Github_UserRepo = $Env:github_user_repo             #User repo to be link to commits
    #     Path = "$PSScriptRoot\Update-History.md"            #Path where to save history
    # }

    Gist = @{
        Id     = $Env:gist_id                               #Your gist id; leave empty for new private or anonymous gist
        ApiKey = $Env:github_api_key                        #Your github api key - if empty anoymous gist is created
        Path   = "$PSScriptRoot\Update-AUPackages.md"       #Update-History.md uploaded separately after custom History plugin runs
    }

    Git = @{
        User     = ''                                       #Git username, leave empty if github api key is used
        Password = $Env:github_api_key                      #Password if username is not empty, otherwise api key
    }

    GitReleases = @{
      ApiToken = $Env:github_api_key
      ReleaseType = 'package'
    }

    RunInfo = @{
        Exclude = 'password', 'apikey', 'apitoken'          #Option keys which contain those words will be removed
        Path    = "$PSScriptRoot\update_info.xml"           #Path where to save the run info
    }

    Mail = if ($Env:mail_user) {
            @{
                To         = $Env:mail_user
                Server     = $Env:mail_server
                UserName   = $Env:mail_user
                Password   = $Env:mail_pass
                Port       = $Env:mail_port
                EnableSsl  = $Env:mail_enablessl -eq 'true'
                Attachment = "$PSScriptRoot\update_info.xml"
                UserMessage = ''
                SendAlways  = $false                        #Send notifications every time
             }
           } else {}

    ForcedPackages = $ForcedPackages -split ' '
    UpdateIconScript = "$PSScriptRoot\scripts\Update-IconUrl.ps1"
    UpdatePackageSourceScript = "$PSScriptRoot\scripts\Update-PackageSourceUrl.ps1"
    ModulePaths = @("$PSScriptRoot\scripts\au_extensions.psm1"; "Wormies-AU-Helpers")
    BeforeEach = {
        param($PackageName, $Options )
        $Options.ModulePaths | % { Import-Module $_ }
        . $Options.UpdateIconScript $PackageName.ToLowerInvariant() -Quiet -ThrowErrorOnIconNotFound
        . $Options.UpdatePackageSourceScript $PackageName.ToLowerInvariant() -Quiet
        if (Test-Path tools) { Expand-Aliases -Directory tools }

        $pattern = "^${PackageName}(?:\\(?<stream>[^:]+))?(?:\:(?<version>.+))?$"
        $p = $Options.ForcedPackages | ? { $_ -match $pattern }
        if (!$p) { return }

        $global:au_Force   = $true
        $global:au_IncludeStream = $Matches['stream']
        $global:au_Version = $Matches['version']
    }
}

if ($ForcedPackages) { Write-Host "FORCED PACKAGES: $ForcedPackages" }
$global:au_Root = $Root                                    #Path to the AU packages
$global:info = updateall -Name $Name -Options $Options

# Run custom History plugin (fixes "Parameter name: length" error in built-in plugin)
& "$PSScriptRoot\scripts\plugins\History.ps1" -Info $global:info -Lines 120 -Github_UserRepo $Env:github_user_repo -Path "$PSScriptRoot\Update-History.md"

# Upload Update-History.md to Gist (must run after custom History plugin generates the file)
if ($Env:github_api_key -and $Env:gist_id) {
    Write-Host "Uploading Update-History.md to Gist"
    $gist_url = "https://api.github.com/gists/$Env:gist_id"
    $gist_headers = @{
        Authorization = "token $Env:github_api_key"
        Accept        = "application/vnd.github.v3+json"
    }
    $history_content = [System.IO.File]::ReadAllText("$PSScriptRoot\Update-History.md")
    if ($history_content) {
        $gist_body = @{
            files = @{
                "Update-History.md" = @{ content = $history_content }
            }
        } | ConvertTo-Json -Depth 3 -Compress
        try {
            $response = Invoke-RestMethod -Uri $gist_url -Method Patch -Headers $gist_headers -Body $gist_body -ContentType "application/json"
            Write-Host "  $($response.html_url)"
        } catch {
            Write-Warning "Failed to upload Update-History.md to Gist: $_"
        }
    }
}

#Uncomment to fail the build on AppVeyor on any package error
#if ($global:info.error_count.total) { throw 'Errors during update' }
