# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@28312650af5f6f365757d0c90621c11154a7c6ae/icons/betterdiscord.png" width="48" height="48"/> [betterdiscord-cli](https://community.chocolatey.org/packages/betterdiscord-cli)

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
