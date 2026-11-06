# G HUB's local API is the agent's WebSocket. It is undocumented, so any failure here means "could not update", never a failed package.
function Invoke-GHubApi([string]$Verb, [string]$Path) {
  $ct = [Threading.CancellationToken]::None
  $ws = New-Object System.Net.WebSockets.ClientWebSocket
  try {
    $ws.Options.Proxy = $null
    $ws.Options.AddSubProtocol('json')
    $ws.Options.SetRequestHeader('Origin', 'file://')
    if (-not $ws.ConnectAsync([Uri]'ws://127.0.0.1:9010/', $ct).Wait(5000)) { throw 'the G HUB API did not accept a connection' }

    $id = [guid]::NewGuid().ToString()
    $bytes = [Text.Encoding]::UTF8.GetBytes((@{ msgId = $id; verb = $Verb; path = $Path } | ConvertTo-Json -Compress))
    if (-not $ws.SendAsync([ArraySegment[byte]]::new($bytes), 'Text', $true, $ct).Wait(5000)) { throw "the G HUB API did not take $Verb $Path" }

    # The API also sends messages of its own, so read until the reply with this id arrives
    $buffer = New-Object byte[] 65536
    $deadline = (Get-Date).AddSeconds(15)
    while ($true) {
      $message = New-Object IO.MemoryStream
      do {
        $wait = [int]($deadline - (Get-Date)).TotalMilliseconds
        if ($wait -le 0) { throw "the G HUB API did not answer $Verb $Path" }
        $receive = $ws.ReceiveAsync([ArraySegment[byte]]::new($buffer), $ct)
        if (-not $receive.Wait($wait)) { throw "the G HUB API did not answer $Verb $Path" }
        $message.Write($buffer, 0, $receive.Result.Count)
      } until ($receive.Result.EndOfMessage)

      $text = [Text.Encoding]::UTF8.GetString($message.ToArray())
      if ($text.Contains($id)) {
        $reply = $text | ConvertFrom-Json
        if ($reply.result.code -ne 'SUCCESS') { throw "the G HUB API answered $($reply.result.code) to $Verb $Path" }
        return $reply.payload
      }
    }
  } finally {
    $ws.Dispose()
  }
}

function Get-GHubVersion {
  try { (Get-Content (Join-Path $env:ProgramData 'LGHUB\version.json') -Raw | ConvertFrom-Json).version } catch { $null }
}

function Get-GHubUpdateState {
  try { (Invoke-GHubApi 'GET' '/updates/status').state } catch { 'UNREACHABLE' }
}

function Update-InstalledGHub([string]$InstallDir) {
  $before = Get-GHubVersion
  $wanted = [version]([version]$env:ChocolateyPackageVersion).ToString(3)
  $busy = 'CHECKING_FOR_UPDATES', 'UPDATE_DOWNLOADING', 'UPDATE_UNPACKING', 'UPDATE_INSTALLING'

  try {
    if ((Get-GHubUpdateState) -eq 'UNREACHABLE') {
      # G HUB was quit, so its agent is down. explorer starts it as the signed-in user, not elevated like this script.
      $agent = Join-Path $InstallDir 'lghub_agent.exe'
      if ([Security.Principal.WindowsIdentity]::GetCurrent().IsSystem -or -not (Test-Path $agent)) { throw 'G HUB is not running and could not be started' }
      Start-Process -FilePath 'explorer.exe' -ArgumentList "`"$agent`""
      $deadline = (Get-Date).AddSeconds(45)
      while ((Get-Date) -lt $deadline -and (Get-GHubUpdateState) -eq 'UNREACHABLE') { Start-Sleep -Seconds 3 }
      if ((Get-GHubUpdateState) -eq 'UNREACHABLE') { throw 'G HUB is not running and could not be started' }
    }

    Write-Host "G HUB $before is installed. Checking for an update..."
    $null = Invoke-GHubApi 'SET' '/updates/check_now'
    $stage = 'check'
    $asked = Get-Date
    $state = ''
    $deadline = (Get-Date).AddMinutes(30)
    while ((Get-Date) -lt $deadline) {
      Start-Sleep -Seconds 5
      $state = Get-GHubUpdateState
      $now = Get-GHubVersion

      if ($state -eq 'NO_UPDATES' -and $now) {
        if ($now -ne $before) { Write-Host "G HUB was updated from $before to $now."; return }
        if ([version]$now -ge $wanted) { Write-Host "G HUB $now is up to date."; return }
      }

      if ($state -eq 'UPDATE_AVAILABLE' -and $stage -eq 'check') {
        Write-Host 'Downloading the G HUB update...'
        $null = Invoke-GHubApi 'SET' '/updates/download'
        $stage = 'download'
        $asked = Get-Date
      } elseif ($state -eq 'UPDATE_READY' -and $stage -ne 'install') {
        Write-Host 'Installing the G HUB update. G HUB closes and reopens...'
        $null = Invoke-GHubApi 'SET' '/updates/install'
        $stage = 'install'
        $asked = Get-Date
      } elseif ($state -notin $busy -and ((Get-Date) - $asked).TotalSeconds -gt 120) {
        throw "its updater stopped at $state"
      }
    }
    throw "its updater was still at $state after 30 minutes"
  } catch {
    Write-Warning "G HUB was not updated and stays on ${before}: $($_.Exception.Message). Open G HUB and accept its update prompt, or run 'choco install lghub --force' to try again."
  }
}
