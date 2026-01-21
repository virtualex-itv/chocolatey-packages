# <img src="https://rawcdn.githack.com/virtualex-itv/chocolatey-packages/227e188880b4e4f7be42a32d31d8b60b74c0119c/icons/laps.png" width="48" height="48"/> [laps](https://community.chocolatey.org/packages/laps)

---

> **DEPRECATION NOTICE**
>
> **Legacy Microsoft LAPS is deprecated** as of Windows 11 23H2 and later. The MSI installer is blocked on newer Windows versions and Microsoft no longer develops this product.
>
> **For new deployments**, use [Windows LAPS](https://learn.microsoft.com/en-us/windows-server/identity/laps/laps-overview) which is built into Windows 10/11 and Windows Server 2019/2022 (April 2023 security updates and later). No separate installation required.
>
> This package remains available for **legacy systems** (Windows 10 pre-23H2, Windows Server 2016, etc.) until they reach end-of-life.

---

## Package Parameters

* if the parameter is not specified, only the AdmPwd GPO Extension is installed (default)
* `/ALL` - Installs the AdmPwd GPO Extension and all Management Tools (Fat client UI, PowerShell module, and GPO Editor templates)
Example:

```shell
choco install laps --params='"/ALL"'
```

---

## Overview of Local Administrator Password Solution

For environments in which users are required to log on to computers without domain credentials, password management can become a complex issue. Such environments greatly increase the risk of a Pass-the-Hash (PtH) credential replay attack. The Local Administrator Password Solution (LAPS) provides a solution to this issue of using a common local account with an identical password on every computer in a domain. LAPS resolves this issue by setting a different, random password for the common local administrator account on every computer in the domain. Domain administrators using the solution can determine which users, such as helpdesk administrators, are authorized to read passwords.

LAPS simplifies password management while helping customers implement recommended defenses against cyberattacks. In particular, the solution mitigates the risk of lateral escalation that results when customers use the same administrative local account and password combination on their computers. LAPS stores the password for each computer’s local administrator account in Active Directory, secured in a confidential attribute in the computer’s corresponding Active Directory object. The computer is allowed to update its own password data in Active Directory, and domain administrators can grant read access to authorized users or groups, such as workstation helpdesk administrators.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.
