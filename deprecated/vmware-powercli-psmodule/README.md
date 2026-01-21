# [DEPRECATED] vmware-powercli-psmodule

## This package has been deprecated

VMware.PowerCLI has been deprecated by Broadcom and rebranded to **VCF.PowerCLI** (VMware Cloud Foundation PowerCLI).

As of July 2025, the VMware.PowerCLI module on PSGallery displays a deprecation notice directing users to use VCF.PowerCLI instead. The underlying cmdlets and functionality remain the same—the change is purely a rebranding as part of Broadcom's VMware Cloud Foundation strategy.

## Replacement

Use **[vcf-powercli-psmodule](https://community.chocolatey.org/packages/vcf-powercli-psmodule)** instead.

To install VCF.PowerCLI:

```powershell
choco install vcf-powercli-psmodule
```

## What happens when you install this package?

This deprecated package depends on `vcf-powercli-psmodule`. When you install or update the `vmware-powercli-psmodule` package, VCF.PowerCLI will be installed automatically as a replacement.

## Package Parameters

The replacement package is designed to install the `VCF.PowerCLI` PowerShell module for the `-Scope CurrentUser` by default.

The following parameter is available to install the module for `-Scope AllUsers`.

* `/ALLUSERS`

Example:

```powershell
choco install vcf-powercli-psmodule --params='"/ALLUSERS"'
```

For more information, visit: <https://developer.broadcom.com/powercli>
