# <img src="https://rawcdn.githack.com/virtualex-itv/chocolatey-packages/227e188880b4e4f7be42a32d31d8b60b74c0119c/icons/laps.png" width="32" height="32"/> [![Microsoft Local Administrator Password Solution (LAPS)](https://img.shields.io/chocolatey/v/laps.svg?label=Microsoft+Local+Administrator+Password+Solution+(LAPS))](https://chocolatey.org/packages/laps) [![Microsoft Local Administrator Password Solution (LAPS)](https://img.shields.io/chocolatey/dt/laps.svg)](https://chocolatey.org/packages/laps)

## Usage

To install Microsoft Local Administrator Password Solution (LAPS), run the following command from the command line or from PowerShell:

```powershell
choco install laps
```

To upgrade Microsoft Local Administrator Password Solution (LAPS), run the following command from the command line or from PowerShell:

```powershell
choco upgrade laps
```

To uninstall Microsoft Local Administrator Password Solution (LAPS), run the following command from the command line or from PowerShell:

```powershell
choco uninstall laps
```

## Description

---

### Package Parameters

* if the parameter is not specified, only the AdmPwd GPO Extension is installed (default)
* `/ALL` - Installs the AdmPwd GPO Extension and all Management Tools (Fat client UI, PowerShell module, and GPO Editor templates)
Example: `choco install laps --params='"/ALL"'`

---

### Overview of Local Administrator Password Solution

For environments in which users are required to log on to computers without domain credentials, password management can become a complex issue. Such environments greatly increase the risk of a Pass-the-Hash (PtH) credential replay attack. The Local Administrator Password Solution (LAPS) provides a solution to this issue of using a common local account with an identical password on every computer in a domain. LAPS resolves this issue by setting a different, random password for the common local administrator account on every computer in the domain. Domain administrators using the solution can determine which users, such as helpdesk administrators, are authorized to read passwords.

LAPS simplifies password management while helping customers implement recommended defenses against cyberattacks. In particular, the solution mitigates the risk of lateral escalation that results when customers use the same administrative local account and password combination on their computers. LAPS stores the password for each computer’s local administrator account in Active Directory, secured in a confidential attribute in the computer’s corresponding Active Directory object. The computer is allowed to update its own password data in Active Directory, and domain administrators can grant read access to authorized users or groups, such as workstation helpdesk administrators.

**Please Note**: This is an automatically updated package. If you find it is
out of date by more than a day or two, please contact the maintainer(s) and
let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://chocolatey.org/packages/laps)

[Software Site](https://www.microsoft.com/en-us/download/details.aspx?id=46899)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/laps)
