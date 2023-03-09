#Requires AutoHotkey v2
#Warn  ; Enable warnings to assist with detecting common errors.
#NoTrayIcon
SetTitleMatchMode 1
SetControlDelay -1

WinWait("ahk_class NSISBGImage")
if WinExist("ahk_class NSISBGImage") {
  sleep 5000
}

winTitle := "ahk_exe BetterDiscord.exe"
If WinExist(winTitle)
  WinActivate

WinWait(winTitle,, 360)

sleep 1500

; Accept License
sleep 1000
SetControlDelay -1
ControlClick "x30 y283", winTitle,,,, "Pos"

; Next
sleep 1000
ControlClick "x500 y315", winTitle,,,, "Pos"

; Next
sleep 1000
ControlClick "x500 y315", winTitle,,,, "Pos"

; Check if path selected
sleep 1000
CoordMode "Pixel", "Window"
Color := PixelGetColor(320, 96)
If (Color = 0x15141C or Color != 0x15141C) {
    ControlClick "x320 y96", winTitle,,,, "Pos"
}

; Install
sleep 1000
ControlClick "x500 y315", winTitle,,,, "Pos"

; Wait for exit button
sleep 12000

; Close
ControlClick "x500 y315", winTitle,,,, "Pos"

Exit
