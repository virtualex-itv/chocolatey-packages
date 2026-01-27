#  [![[Deprecated] VMware.PowerCLI (PowerShell Module)](https://img.shields.io/chocolatey/v/vmware-powercli-psmodule.svg?label=%5BDeprecated%5D+VMware.PowerCLI+(PowerShell+Module))](https://community.chocolatey.org/packages/vmware-powercli-psmodule) [![[Deprecated] VMware.PowerCLI (PowerShell Module)](https://img.shields.io/chocolatey/dt/vmware-powercli-psmodule.svg)](https://community.chocolatey.org/packages/vmware-powercli-psmodule)

## Usage

To install [Deprecated] VMware.PowerCLI (PowerShell Module), run the following command from the command line or from PowerShell:

```powershell
choco install vmware-powercli-psmodule
```

To upgrade [Deprecated] VMware.PowerCLI (PowerShell Module), run the following command from the command line or from PowerShell:

```powershell
choco upgrade vmware-powercli-psmodule
```

To uninstall [Deprecated] VMware.PowerCLI (PowerShell Module), run the following command from the command line or from PowerShell:

```powershell
choco uninstall vmware-powercli-psmodule
```

## Description

## DEPRECATED

VMware.PowerCLI has been deprecated by Broadcom and rebranded to **VCF.PowerCLI** (VMware Cloud Foundation PowerCLI).

As of July 2025, the VMware.PowerCLI module on PSGallery displays a deprecation notice directing users to use VCF.PowerCLI instead. The underlying cmdlets and functionality remain the same—the change is purely a rebranding as part of Broadcom's VMware Cloud Foundation strategy.

### What happens when you install this package?

This deprecated package will automatically install the replacement package **[vcf-powercli-psmodule](https://community.chocolatey.org/packages/vcf-powercli-psmodule)** as a dependency.

---

## Package Parameters

The replacement package is designed to install the `VCF.PowerCLI` PowerShell module for the `-Scope CurrentUser` by default.

The following parameter is available to install the module for `-Scope AllUsers`.

* `/ALLUSERS`

Example:
```powershell
choco install vcf-powercli-psmodule --params='"/ALLUSERS"'
```

---

### Migration

To migrate manually:
```powershell
choco uninstall vmware-powercli-psmodule
choco install vcf-powercli-psmodule
```

Or simply update, and the dependency will handle the transition:
```powershell
choco upgrade vmware-powercli-psmodule
```


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/vmware-powercli-psmodule)

[Software Site](https://developer.broadcom.com/powercli)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/deprecated/vmware-powercli-psmodule)

