# <img src="" width="48" height="48"/> [noctty](https://community.chocolatey.org/packages/noctty)

noctty is a native Win32 terminal emulator for Windows 10 and 11 (x64 and ARM64). It runs Ghostty's terminal core - parsing, fonts, rendering, input and shell integration - inside a native Windows app with its own windowing, tabs, splits, settings window and updater.

### Features

* Tabs and splits, with session restoration of windows, tabs, splits, working directories, profiles and titles
* Per-pane shells: PowerShell, cmd, Git Bash or WSL
* Universal command palette (Ctrl+Shift+P) for actions, tabs, panes, profiles, themes and settings
* Native settings window that only writes the lines you change, or edit %LOCALAPPDATA%\noctty\config.ghostty directly
* No telemetry; the app checks for updates at most once a day and the check can be switched off with auto-update = off

### Package Notes

* The release installer is signed with a self-signed certificate, so Windows SmartScreen may warn on a manual run. This package verifies the download against the SHA-256 published with each release.
* The installer does not add noctty to PATH.
* noctty is independent and not affiliated with the Ghostty project.
* The in-app updater is separate from Chocolatey. Use choco upgrade noctty to keep package metadata in sync.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.
