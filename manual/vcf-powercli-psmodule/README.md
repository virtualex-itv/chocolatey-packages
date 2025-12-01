# <img src="https://rawcdn.githack.com/virtualex-itv/chocolatey-packages/6aa0e16032e742aaea35f0cd428fb310f77a57dc/icons/vmware-powercli-psmodule.png" width="48" height="48"/> [vcf-powercli-psmodule](https://community.chocolatey.org/packages/vcf-powercli-psmodule)

---

## Package Parameters

This package is designed to install the `VCF.PowerCLI` PowerShell module for the `-Scope CurrentUser` by default.

The following parameter is available to install the module for `-Scope AllUsers`.

* `/ALLUSERS`
Example:

```shell
choco install vcf-powercli-psmodule --params='"/ALLUSERS"'
```

---

PowerCLI is a command-line interface for managing and automating all aspects of vSphere management, including network, storage, VM, guest OS and more.  PowerCLI is distributed as PowerShell modules, which contain a combined number of over 700 cmdlets (commands.)

**Please Note**: This package supersedes [vmware-powercli-psmodule](https://community.chocolatey.org/packages/vmware-powercli-psmodule).  If this package is detected, it will be removed prior to installing this new package.
