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
;   3. success.tsx  - one button: "Launch Hermes"           (we close, don't launch)
;   4. failure.tsx  - error screen                          (we bail)
; ============================================================================

TraySetIcon "*"  ; suppress default tray icon

SetTitleMatchMode 2     ; partial title match

windowMatch      := "Hermes ahk_exe Hermes-Setup.exe"
windowWaitSec    := 30          ; wait up to 30s for the bootstrap UI to launch
installTimeoutMs := 1800000     ; 30 min wall-clock for the install itself
pollIntervalMs   := 2000
markerFile       := A_AppData . "\..\Local\hermes\hermes-agent\.hermes-bootstrap-complete"
; A_AppData is Roaming; resolve LOCALAPPDATA directly for clarity
markerFile := EnvGet("LOCALAPPDATA") . "\hermes\hermes-agent\.hermes-bootstrap-complete"

; ---- Phase 1: wait for the wizard window ---------------------------------
if !WinWait(windowMatch, , windowWaitSec) {
    FileAppend "hermes-clickthrough: Hermes Setup window never appeared (timeout)`n", "*"
    ExitApp 10
}

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

; ---- Phase 3: wait for completion ----------------------------------------
; install.ps1 drops .hermes-bootstrap-complete in the agent dir when its
; first-launch setup finishes (see apps/desktop/README.md "Troubleshooting").
; If the window vanishes first, accept that too.
elapsed := 0
Loop {
    Sleep pollIntervalMs
    elapsed += pollIntervalMs

    if FileExist(markerFile)
        break

    if !WinExist(windowMatch)
        break    ; installer window closed itself; treat as done

    if (elapsed >= installTimeoutMs) {
        FileAppend "hermes-clickthrough: install did not complete within " . installTimeoutMs . "ms`n", "*"
        if WinExist(windowMatch)
            WinClose windowMatch
        ExitApp 11
    }
}

; ---- Phase 4: close the Success window so Hermes-Setup.exe exits ---------
; The wizard sits on the Success screen waiting for "Launch Hermes". We don't
; launch (Chocolatey convention: don't auto-launch installed apps), we just
; close so the parent installer process can return to choco.
if WinExist(windowMatch) {
    WinActivate windowMatch
    Sleep 500
    WinClose windowMatch, , 5
}

ExitApp 0
