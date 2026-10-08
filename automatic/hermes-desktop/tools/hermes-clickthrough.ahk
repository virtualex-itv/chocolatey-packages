#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; Hermes Setup wizard click-through driver  (AutoHotkey v2)
; ----------------------------------------------------------------------------
; Hermes-Setup.exe is a Tauri-built GUI bootstrap that wraps the official
; scripts/install.ps1. Its tauri.conf.json defines no CLI plugin, so a silent
; install has to drive the wizard from the outside.
;
; Wizard layout (apps/bootstrap-installer/src/routes):
;   1. welcome.tsx  - one button: "Install Hermes"          (we click this)
;   2. progress.tsx - no buttons, just progress             (we wait)
;   3. success.tsx  - one button: "Launch"                  (we close, don't launch)
;   4. failure.tsx  - error screen                          (we bail)
;
; Arguments: A_Args[1] = bootstrap marker path, A_Args[2] = log file path.
; chocolateyInstall.ps1 passes both and echoes the log into the choco output.
; ============================================================================

TraySetIcon "*"  ; suppress default tray icon

SetTitleMatchMode 2     ; partial title match

windowMatch      := "Hermes ahk_exe Hermes-Setup.exe"
windowWaitSec    := 30          ; wait up to 30s for the bootstrap UI to launch
installTimeoutMs := 1800000     ; 30 min wall-clock for the install itself
pollIntervalMs   := 2000
closeGraceMs     := 15000       ; how long WM_CLOSE gets before the process is ended
markerFile := A_Args.Length >= 1 ? A_Args[1] : EnvGet("LOCALAPPDATA") . "\hermes\hermes-agent\.hermes-bootstrap-complete"
logFile    := A_Args.Length >= 2 ? A_Args[2] : A_Temp . "\hermes-clickthrough.log"

try FileDelete logFile

Log(msg) {
    global logFile
    FileAppend FormatTime(, "HH:mm:ss") . " " . msg . "`n", logFile
}

; ---- Phase 1: wait for the wizard window ---------------------------------
if !WinWait(windowMatch, , windowWaitSec) {
    Log("Hermes Setup window never appeared within " . windowWaitSec . "s")
    ExitApp 10
}
setupPid := WinGetPID(windowMatch)
Log("Setup window found (pid " . setupPid . ")")

WinActivate windowMatch
WinWaitActive windowMatch, , 5
Sleep 2000   ; let WebView2 fully render the welcome screen before interacting

; ---- Phase 2: click "Install Hermes" on the welcome screen ---------------
; WebView2/Tauri windows don't reliably receive Send keystrokes to the page
; content, so do a real mouse click at the button's geometric position.
; tauri.conf.json fixes the wizard at 880x620 with a non-resizable layout,
; and welcome.tsx places its single Button in a vertically-centered flex
; column with the wordmark + description above it. Empirically the button
; sits at roughly ~65% down the client area, horizontally centered.
;
; We click via MouseClick (screen coords) using the window's current position.
WinGetPos &winX, &winY, &winW, &winH, windowMatch
btnX := winX + (winW // 2)
btnY := winY + Round(winH * 0.62)

; Save mouse position so we put it back after - we're being polite, not a robot
MouseGetPos &origX, &origY
CoordMode "Mouse", "Screen"
MouseClick "Left", btnX, btnY, 1, 0
Sleep 500
MouseMove origX, origY, 0
Log("Clicked Install Hermes")

; ---- Phase 3: wait for completion ----------------------------------------
; The bootstrap writes .hermes-bootstrap-complete once every install stage
; has finished. Track the Setup process rather than its window, so a window
; that is briefly undetectable does not end the wait early.
elapsed := 0
Loop {
    Sleep pollIntervalMs
    elapsed += pollIntervalMs

    if FileExist(markerFile) {
        Log("Bootstrap marker found after " . (elapsed // 1000) . "s")
        break
    }

    if !ProcessExist(setupPid) {
        Log("Setup exited before the bootstrap marker appeared")
        ExitApp 12
    }

    if (elapsed >= installTimeoutMs) {
        Log("Install did not complete within " . (installTimeoutMs // 60000) . " min")
        if WinExist("ahk_pid " . setupPid)
            WinClose
        ExitApp 11
    }
}

; ---- Phase 4: close the Success window so Hermes-Setup.exe exits ---------
; Close promptly instead of leaving "Launch" on screen: the Aug 2026
; Hermes-Setup.exe starts the desktop app holding Setup's stdout/stderr,
; which keeps Chocolatey waiting until the desktop app is closed. The marker
; means the install is finished, so ending Setup is safe if WM_CLOSE fails.
Sleep 2000
attempts := 0
deadline := A_TickCount + closeGraceMs
while ProcessExist(setupPid) && (A_TickCount < deadline) {
    if WinExist("ahk_pid " . setupPid) {
        WinClose
        attempts += 1
    }
    Sleep 1000
}

if ProcessExist(setupPid) {
    Log("Setup still running after " . attempts . " close attempt(s); ending it")
    ProcessClose setupPid
} else {
    Log("Setup closed after " . attempts . " close attempt(s)")
}

ExitApp 0
