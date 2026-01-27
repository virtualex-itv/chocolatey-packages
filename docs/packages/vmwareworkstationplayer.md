#  [![[Deprecated] VMware Workstation Player](https://img.shields.io/chocolatey/v/vmware-workstation-player.svg?label=%5BDeprecated%5D+VMware+Workstation+Player)](https://community.chocolatey.org/packages/vmware-workstation-player) [![[Deprecated] VMware Workstation Player](https://img.shields.io/chocolatey/dt/vmware-workstation-player.svg)](https://community.chocolatey.org/packages/vmware-workstation-player)

## Usage

To install [Deprecated] VMware Workstation Player, run the following command from the command line or from PowerShell:

```powershell
choco install vmware-workstation-player
```

To upgrade [Deprecated] VMware Workstation Player, run the following command from the command line or from PowerShell:

```powershell
choco upgrade vmware-workstation-player
```

To uninstall [Deprecated] VMware Workstation Player, run the following command from the command line or from PowerShell:

```powershell
choco uninstall vmware-workstation-player
```

## Description

## DEPRECATED

VMware Workstation Player was **discontinued in May 2024** when VMware Workstation Pro became free for personal use.

As of November 2024, VMware Workstation Pro is **free for all users** (commercial, educational, and personal) and no longer requires a license key.

### Why was Player discontinued?

VMware Workstation Player was a stripped-down version of Workstation Pro. Since Workstation Pro is now free with no functional limitations, there is no longer a need for a separate Player product.

### What happens when you install this package?

This deprecated package depends on **[vmwareworkstation](https://community.chocolatey.org/packages/vmwareworkstation)**, the VMware Workstation Pro package.

**Note:** The vmwareworkstation package has been retired because Broadcom now requires account authentication to download VMware Workstation Pro. See that package for alternatives.

---

### Migration

To migrate manually:
```powershell
choco uninstall vmware-workstation-player
```

### Alternatives

- **VMware Workstation Pro** - Download directly from [Broadcom](https://support.broadcom.com) (free, requires account)
- **VirtualBox** - Free and open source: `choco install virtualbox`
- **Hyper-V** - Built into Windows Pro/Enterprise


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/vmware-workstation-player)

[Software Site](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/deprecated/vmware-workstation-player)

