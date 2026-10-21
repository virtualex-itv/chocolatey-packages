# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@482c05c62d3a2471e4e6850eeb9966f76e263127/icons/policyplus.png" width="32" height="32"/> [![Policy Plus](https://img.shields.io/chocolatey/v/policyplus.svg?label=Policy+Plus)](https://community.chocolatey.org/packages/policyplus) [![Policy Plus](https://img.shields.io/chocolatey/dt/policyplus.svg)](https://community.chocolatey.org/packages/policyplus)

## Usage

To install Policy Plus, run the following command from the command line or from PowerShell:

```powershell
choco install policyplus
```

To upgrade Policy Plus, run the following command from the command line or from PowerShell:

```powershell
choco upgrade policyplus
```

To uninstall Policy Plus, run the following command from the command line or from PowerShell:

```powershell
choco uninstall policyplus
```

## Description

Policy Plus is a local Group Policy editor that works on every edition of Windows, including Home. It reads administrative templates (ADMX/ADML files) and writes the policies they describe, so it can manage settings that the built-in Local Group Policy Editor does not offer on some editions.

### Features

* Works on all Windows editions, including Home
* Searches policies by name, description, registry key or value
* Shows the registry keys and values behind each policy
* Downloads the latest administrative templates from Microsoft
* Imports and exports policy settings as POL files and loads settings from other machines or registry hives
* Detects policies that are set but not configured in the editor, and fixes them

### Package Notes

* This package installs the single portable executable and adds a Start Menu shortcut.
* Policy Plus requires .NET Framework 4.5.2 or newer, which is included with current versions of Windows.
* The project publishes releases named after the month and year (for example October2025), so the package version is YYYY.M.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/policyplus)

[Software Site](https://github.com/Fleex255/PolicyPlus)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/policyplus)
