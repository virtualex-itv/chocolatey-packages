# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@3f0390917b1719767230a4e176a57e5827d9f475/icons/achievements.png" width="32" height="32"/> [![Achievements](https://img.shields.io/chocolatey/v/achievements.svg?label=Achievements)](https://community.chocolatey.org/packages/achievements) [![Achievements](https://img.shields.io/chocolatey/dt/achievements.svg)](https://community.chocolatey.org/packages/achievements)

## Usage

To install Achievements, run the following command from the command line or from PowerShell:

```powershell
choco install achievements
```

To upgrade Achievements, run the following command from the command line or from PowerShell:

```powershell
choco upgrade achievements
```

To uninstall Achievements, run the following command from the command line or from PowerShell:

```powershell
choco uninstall achievements
```

## Description

Achievements is a free, open-source desktop app that watches the games you run and shows animated notifications when you unlock an achievement. It also tracks playtime and progress, offers an in-game overlay and a dashboard of all your games, and can take screenshots or short clips of an unlock.

It reads achievement data for games from several sources, including Xbox PC, RetroAchievements and the RPCS3 and ShadPS4 console emulators, as well as game launcher and local save formats.

### Package Notes

* This package installs the 64-bit installer published by the project on GitHub. The installer needs administrator rights and installs the app for all users in `C:\Program Files\Achievements`.
* The installer is signed with the author's own certificate (`JokerVerse`), which Windows does not trust, so SmartScreen may warn if the installer is downloaded by hand. Chocolatey verifies the SHA-256 checksum of the download instead.
* The installer is large (about 325 MB) because it bundles a full Chromium runtime.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/achievements)

[Software Site](https://pserban93.github.io/Achievements-Docs/)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/achievements)
