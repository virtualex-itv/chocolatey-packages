# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@28312650af5f6f365757d0c90621c11154a7c6ae/icons/betterdiscord.png" width="32" height="32"/> [![BetterDiscord CLI](https://img.shields.io/chocolatey/v/betterdiscord-cli.svg?label=BetterDiscord+CLI)](https://community.chocolatey.org/packages/betterdiscord-cli) [![BetterDiscord CLI](https://img.shields.io/chocolatey/dt/betterdiscord-cli.svg)](https://community.chocolatey.org/packages/betterdiscord-cli)

## Usage

To install BetterDiscord CLI, run the following command from the command line or from PowerShell:

```powershell
choco install betterdiscord-cli
```

To upgrade BetterDiscord CLI, run the following command from the command line or from PowerShell:

```powershell
choco upgrade betterdiscord-cli
```

To uninstall BetterDiscord CLI, run the following command from the command line or from PowerShell:

```powershell
choco uninstall betterdiscord-cli
```

## Description

BetterDiscord CLI (`bdcli`) is a native Go command-line tool for installing, removing, and maintaining [BetterDiscord](https://betterdiscord.app/) across supported Discord desktop installations.

### Features

* Install and uninstall BetterDiscord without the graphical installer
* Supports the Stable, PTB, and Canary Discord channels
* Automatically stops and restarts Discord during install/uninstall
* Discover Discord installations and suggested paths
* Manage plugins and themes (list, install, update, remove)
* Browse and search the BetterDiscord addon store

### Usage

```shell
bdcli install --channel stable
bdcli info
bdcli update
bdcli uninstall --channel stable
```

Run `bdcli [command] --help` for command-specific flags.

This package installs the CLI only - it does not inject BetterDiscord into Discord on its own. Run `bdcli install` afterwards, or use the `betterdiscord` package.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/betterdiscord-cli)

[Software Site](https://betterdiscord.app/)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/betterdiscord-cli)
