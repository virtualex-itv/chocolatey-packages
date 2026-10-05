# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@6e0ab2474d0021afcfdc4ae12e4561efc3cd54e8/icons/logioptionsplus.png" width="32" height="32"/> [![Logi Options+](https://img.shields.io/chocolatey/v/logioptionsplus.svg?label=Logi+Options%2B)](https://community.chocolatey.org/packages/logioptionsplus) [![Logi Options+](https://img.shields.io/chocolatey/dt/logioptionsplus.svg)](https://community.chocolatey.org/packages/logioptionsplus)

## Usage

To install Logi Options+, run the following command from the command line or from PowerShell:

```powershell
choco install logioptionsplus
```

To upgrade Logi Options+, run the following command from the command line or from PowerShell:

```powershell
choco upgrade logioptionsplus
```

To uninstall Logi Options+, run the following command from the command line or from PowerShell:

```powershell
choco uninstall logioptionsplus
```

## Description

Easier and more productive are the goals. How you do it is up to you. Logi Options+ is the next-gen app that lets you manage and customize your supported mice and supported keyboards —so they all seamlessly work to support you. Options+ is designed to transform how you work.

## Package Parameters

* `/Offline` - Install with Logitech's offline installer instead of the default online installer. The online installer downloads the app during setup, which can fail behind a corporate proxy or firewall; the offline installer (about 725 MB) contains everything it needs.

Example:

```shell
choco install logioptionsplus --params='"/Offline"'
```

Logitech documents these differences for the offline version: Logi account sign-in, Backup & Restore, Smart Actions and Logi Voice are not available, and Flow is disabled unless enabled during a silent install. To switch an existing offline installation back to the online version, Logitech says to uninstall it first. Pass `/Offline` on every upgrade, or have choco remember it with `choco feature enable -n=useRememberedArgumentsForUpgrades`.

Logitech's installer feature flags (for example `/update yes` or `/flow yes`) can be added with `--install-arguments`.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/logioptionsplus)

[Software Site](https://www.logitech.com/en-us/software/logi-options-plus.html)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/logioptionsplus)
