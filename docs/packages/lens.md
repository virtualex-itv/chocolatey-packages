# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@1f7b6b334898ed930db76bf701e3b59d3b61faf0/icons/lens.png" width="32" height="32"/> [![Lens](https://img.shields.io/chocolatey/v/lens.svg?label=Lens)](https://community.chocolatey.org/packages/lens) [![Lens](https://img.shields.io/chocolatey/dt/lens.svg)](https://community.chocolatey.org/packages/lens)

## Usage

To install Lens, run the following command from the command line or from PowerShell:

```powershell
choco install lens
```

To upgrade Lens, run the following command from the command line or from PowerShell:

```powershell
choco upgrade lens
```

To uninstall Lens, run the following command from the command line or from PowerShell:

```powershell
choco uninstall lens
```

## Description

Lens is the only IDE you’ll ever need to take control of your Kubernetes clusters.  Lens is open source and free.

* **Note:** By default, this package will install for all users, however, the following parameter is available to install into the current user profile: `/CURRENTUSER`

Example:

```shell
choco install lens --params='"/CURRENTUSER"'
```

To have choco remember parameters on upgrade, be sure to set:

```shell
choco feature enable -n=useRememberedArgumentsForUpgrades
```

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/lens)

[Software Site](https://k8slens.dev/)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/lens)

