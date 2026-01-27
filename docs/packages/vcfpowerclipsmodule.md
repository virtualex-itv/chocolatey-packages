# <img src="https://rawcdn.githack.com/virtualex-itv/chocolatey-packages/6aa0e16032e742aaea35f0cd428fb310f77a57dc/icons/vmware-powercli-psmodule.png" width="32" height="32"/> [![VCF.PowerCLI (PowerShell Module)](https://img.shields.io/chocolatey/v/vcf-powercli-psmodule.svg?label=VCF.PowerCLI+(PowerShell+Module))](https://community.chocolatey.org/packages/vcf-powercli-psmodule) [![VCF.PowerCLI (PowerShell Module)](https://img.shields.io/chocolatey/dt/vcf-powercli-psmodule.svg)](https://community.chocolatey.org/packages/vcf-powercli-psmodule)

## Usage

To install VCF.PowerCLI (PowerShell Module), run the following command from the command line or from PowerShell:

```powershell
choco install vcf-powercli-psmodule
```

To upgrade VCF.PowerCLI (PowerShell Module), run the following command from the command line or from PowerShell:

```powershell
choco upgrade vcf-powercli-psmodule
```

To uninstall VCF.PowerCLI (PowerShell Module), run the following command from the command line or from PowerShell:

```powershell
choco uninstall vcf-powercli-psmodule
```

## Description


## Package Parameters

This package is designed to install the `VCF.PowerCLI` PowerShell module for the `-Scope CurrentUser` by default.

The following parameter is available to install the module for `-Scope AllUsers`.

* `/ALLUSERS` - Install the module for all users instead of current user only
* `/V7` - Install the module via PowerShell 7 (ensures module is available in pwsh sessions)

Examples:

```shell
choco install vcf-powercli-psmodule --params='"/ALLUSERS"'
choco install vcf-powercli-psmodule --params='"/V7"'
choco install vcf-powercli-psmodule --params='"/ALLUSERS /V7"'
```

---

PowerCLI is a command-line interface for managing and automating all aspects of vSphere management, including network, storage, VM, guest OS and more.  PowerCLI is distributed as PowerShell modules, which contain a combined number of over 700 cmdlets (commands.)

**Please Note**: This package supersedes [vmware-powercli-psmodule](https://community.chocolatey.org/packages/vmware-powercli-psmodule).  If this package is detected, it will be removed prior to installing this new package.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/vcf-powercli-psmodule)

[Software Site](https://developer.broadcom.com/powercli)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/vcf-powercli-psmodule)

