# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@f102da8c83fee58418deb2e30dee311f510a403f/icons/bossanova.png" width="32" height="32"/> [![Bossanova](https://img.shields.io/chocolatey/v/bossanova.svg?label=Bossanova)](https://community.chocolatey.org/packages/bossanova) [![Bossanova](https://img.shields.io/chocolatey/dt/bossanova.svg)](https://community.chocolatey.org/packages/bossanova)

## Usage

To install Bossanova, run the following command from the command line or from PowerShell:

```powershell
choco install bossanova
```

To upgrade Bossanova, run the following command from the command line or from PowerShell:

```powershell
choco upgrade bossanova
```

To uninstall Bossanova, run the following command from the command line or from PowerShell:

```powershell
choco uninstall bossanova
```

## Description

Bossanova keeps the information you use often, such as personal details, company information, API keys and images, in an encrypted vault on your own computer. The vault contents are never uploaded to a server. You can view, search and copy items yourself, or connect an AI app such as ChatGPT, Claude or Gemini so it can use stored values on your behalf through optional MCP tools.

### Features

* Encrypted local vault for text, images and API credentials, protected by a master password
* Find items quickly by name or description
* Optional MCP tools that let an AI app use a stored credential in an HTTPS request or a program run, only after you approve each connection, item and operation on an approval card
* Values you mark as secret are never handed to the AI; only values marked "Not a secret" can be read by it

### Package Notes

* Bossanova is proprietary software with a free tier and paid subscriptions. The permanent Free tier includes 10 fields and one active vault device; Plus and Pro add more. See https://bsnv.app/pricing for the current limits.
* A TINYGEM account is required. Getting started needs a sign-in and device approval, even with a free account, and the app checks its license online from time to time (paid features keep working offline for up to seven days after the last check).
* The installer is downloaded from the vendor at install time, is signed by TINYGEM and runs silently.
* Bossanova installs per user, into %LOCALAPPDATA%\Bossanova of the account that runs Chocolatey, and adds Start menu and Desktop shortcuts.
* Uninstalling removes the application and keeps your vaults.
* The approved service or program receives the value it uses; Bossanova does not isolate other files, process memory or the clipboard.
* 64-bit Windows 10 or 11.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/bossanova)

[Software Site](https://bsnv.app/)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/bossanova)
