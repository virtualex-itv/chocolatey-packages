# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@1d9c6b37c791b0ff8aaac845f6911fea0cca77ac/icons/supermium.png" width="32" height="32"/> [![Supermium](https://img.shields.io/chocolatey/v/supermium.svg?label=Supermium)](https://community.chocolatey.org/packages/supermium) [![Supermium](https://img.shields.io/chocolatey/dt/supermium.svg)](https://community.chocolatey.org/packages/supermium)

## Usage

To install Supermium, run the following command from the command line or from PowerShell:

```powershell
choco install supermium
```

To upgrade Supermium, run the following command from the command line or from PowerShell:

```powershell
choco upgrade supermium
```

To uninstall Supermium, run the following command from the command line or from PowerShell:

```powershell
choco uninstall supermium
```

## Description

Supermium is a free, open source web browser built from current Chromium code that keeps working on older versions of Windows, including Windows XP, Vista, 7 and 8.x, as well as Windows 10 and 11.

### Features

* Based on up-to-date Chromium, with security fixes from upstream (the project says it generally ships them within a week of disclosure)
* A working sandbox for added security
* Aero Glass style window frames, plus options for classic tab shapes and a classic interface
* Google Sync, Widevine DRM playback on Windows 7 and later, and Manifest V2 extension support
* Many flags carried over from ungoogled-chromium

### Package Notes

* This package installs for all users, with Start menu and desktop shortcuts. On 64-bit Windows it installs the 64-bit build for Windows 10 and 11; on 32-bit Windows it installs the 32-bit build.
* The installer is not code signed, so Windows SmartScreen may warn on a manual download.
* Apps and features may show an older version string than the browser itself; check chrome://version for the real one.
* Uninstalling keeps your browser profile (bookmarks, settings and history).
* The package version is built from the release tag: v150-r2.01 is package version 150.2.1.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/supermium)

[Software Site](https://www.supermium.net/)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/supermium)
