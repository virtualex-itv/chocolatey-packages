# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@96d8d5005c0b04d2f497379838c0ff8f3f941ce0/icons/lghub.png" width="32" height="32"/> [![lghub (Install)](https://img.shields.io/chocolatey/v/lghub.svg?label=lghub+(Install))](https://community.chocolatey.org/packages/lghub) [![lghub (Install)](https://img.shields.io/chocolatey/dt/lghub.svg)](https://community.chocolatey.org/packages/lghub)

## Usage

To install lghub (Install), run the following command from the command line or from PowerShell:

```powershell
choco install lghub
```

To upgrade lghub (Install), run the following command from the command line or from PowerShell:

```powershell
choco upgrade lghub
```

To uninstall lghub (Install), run the following command from the command line or from PowerShell:

```powershell
choco uninstall lghub
```

## Description

G HUB recognizes your supported Logitech G gear, and gives you full access to their customization features. It automatically keeps firmware up to date.

## CONFIGURE. SHARE. WIN.

Download profiles from your fellow players, gaming pros and popular streamers. It’s an easy way to try new mouse, keybind, and macros to enhance your game.

## CONTROL YOUR STREAM

Program buttons with in-app actions and create your own macros to launch media and switch scenes. Use your gaming gear to take command of OBS Studio for a faster and more seamless stream.

## COLORIZE AND SYNC YOUR GEAR

Choose from numerous animation effects, download lighting profiles from the community, and create your own advanced effects with Logitech G LIGHTSYNC for keyboards, mice, headsets, and speakers.

## Package Notes

* The installer is Logitech's small setup program, which downloads G HUB when it runs. Logitech rolls each new build out in stages and decides per machine which build it gets, so during a rollout your machine can get a newer build than the package version. The package version follows Logitech's public update feed, which moves when a rollout finishes.
* If G HUB is already installed, the setup program does nothing, so the package updates G HUB through G HUB's own local update service instead. This works with G HUB's automatic updates turned off and leaves that setting alone. G HUB closes and reopens while it updates. If the update cannot run, the package shows a warning and G HUB stays as it is, and you can still accept G HUB's own update prompt.
* To get Logitech's canary (early access) build without waiting for the rollout, pass `/Canary`: `choco install lghub --params "'/Canary'"`. Canary builds can be less stable, and the machine stays on the canary channel until G HUB is uninstalled. This applies to a fresh install only: if G HUB is already installed, `/Canary` is ignored with a warning, so uninstall G HUB first to switch.
* The setup program needs the Microsoft Visual C++ runtime, which the package installs as a dependency.
* Uninstalling this package removes G HUB but keeps your settings and profiles in `%LOCALAPPDATA%\LGHUB`, so a later install picks them up. G HUB's automatic updates setting goes back to on after a reinstall.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/lghub)

[Software Site](https://www.logitechg.com/en-us/innovation/g-hub.html)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/lghub)
