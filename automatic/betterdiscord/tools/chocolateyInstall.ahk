#Requires AutoHotkey v2
#Warn
#NoTrayIcon
SetTitleMatchMode 2
SetControlDelay -1
CoordMode "Pixel", "Client"

; BetterDiscord Installer 2.0.0+ is a Wails app (class wailsWindow), frameless at
; 550x350, so client coords line up with what is on screen. The wizard runs
;   License -> (Action / Configure, varies) -> Versions -> Progress
; with the primary button in the same spot throughout. The license checkbox and the
; Discord version row are NOT pre-selected, so each needs an explicit click; the
; action page already defaults to "Install BetterDiscord".
winTitle   := "ahk_class wailsWindow"
primary    := "x503 y316"   ; Next / Install / Quit
accept     := "x30 y282"    ; "I accept the license agreement" checkbox
discordRow := "x200 y105"   ; first Discord install row, left of its Browse button

; Page fingerprint: a coarse grid over the content area. Sampling widely matters - with
; only a few points two pages can fingerprint identically, and a transition then costs
; the full detection timeout instead of being spotted immediately.
PageSig(win) {
    s := "", y := 70
    while (y <= 300) {
        x := 30
        while (x <= 520) {
            try s .= PixelGetColor(x, y) "|"
            catch
                s .= "x|"
            x += 50
        }
        y += 40
    }
    return s
}

; Wait until the page stops changing, i.e. the transition has finished rendering.
; Three matching samples at 200ms is ~600ms, comfortably past a Svelte page transition.
WaitStable(win, timeout := 4000) {
    last := "", steady := 0, waited := 0
    Loop {
        Sleep 200
        waited += 200
        cur := PageSig(win)
        steady := (cur = last) ? steady + 1 : 0
        last := cur
        if (steady >= 2 or waited >= timeout)
            return
    }
}

; Click a control and report whether the page actually changed. Transitions show up
; within a poll or two, so a timeout here means the click was inert - the caller uses
; that as a signal. Keep the timeout tight: it is dead time on every run, paid once to
; recognise the Versions page.
Advance(win, ctrl, timeout := 1500) {
    before := PageSig(win), changed := false, waited := 0
    ControlClick ctrl, win, , , , "Pos"
    Loop {
        Sleep 200
        waited += 200
        if (PageSig(win) != before) {
            changed := true
            break
        }
        if (waited >= timeout)
            break
    }
    if changed
        WaitStable(win)
    return changed
}

; Select an option that is not pre-selected, letting the row highlight settle.
Choose(win, ctrl, timeout := 1500) {
    ControlClick ctrl, win, , , , "Pos"
    WaitStable(win, timeout)
}

; Press the primary button until it stops advancing the wizard. That end state is the
; Versions page, where the button is inert until a Discord install is picked. The
; intermediate pages differ between a fresh install and a forced reinstall, so counting
; them hardcodes a page that may not exist - and clicking through a page that isn't
; there costs a full detection timeout every run.
WalkToVersions(win, primary) {
    Loop 6 {
        if !Advance(win, primary)
            return
    }
}

; Drive the progress page to the end. The primary button is inert while the install
; runs and becomes "Quit" once it finishes; a confirm may appear as its own dialog or
; as an in-window modal. Keep clicking until the window goes away, and if the page has
; sat unchanged for stuckSecs of clicking, close it outright - the PS1 verifies the
; injection separately, so forcing the window shut cannot turn a failure into a false
; success. The progress page updates while installing, so an unchanging page under
; clicks means the wizard will not close itself.
FinishAndClose(win, primary, stuckSecs := 15) {
    lastSig := PageSig(win), steady := 0, attempts := 0
    While WinExist(win) and (attempts < 300) {
        if WinExist("Are you sure?")
            ControlClick "Yes", "Are you sure?"
        else
            ControlClick primary, win, , , , "Pos"
        Sleep 1000
        if !WinExist(win)
            return
        cur := PageSig(win)
        steady := (cur = lastSig) ? steady + 1 : 0
        lastSig := cur
        if (steady >= stuckSecs) {
            WinClose win
            Sleep 2000
            if WinExist(win)
                WinKill win
            return
        }
        attempts += 1
    }
}

if !WinWait(winTitle, , 180)
    ExitApp

WinActivate winTitle
WinWaitActive winTitle, , 15
WaitStable(winTitle)

Choose(winTitle, accept)        ; Next stays disabled until the EULA is accepted
WalkToVersions(winTitle, primary)
Choose(winTitle, discordRow)    ; nothing is selected here by default
Advance(winTitle, primary)      ; starts the install
FinishAndClose(winTitle, primary)
Exit
