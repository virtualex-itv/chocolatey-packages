# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@bcb13d0586f42f7a493cece7db326adc58adcd0c/icons/ayugram.png" width="32" height="32"/> [![AyuGram Desktop](https://img.shields.io/chocolatey/v/ayugram.svg?label=AyuGram+Desktop)](https://community.chocolatey.org/packages/ayugram) [![AyuGram Desktop](https://img.shields.io/chocolatey/dt/ayugram.svg)](https://community.chocolatey.org/packages/ayugram)

## Usage

To install AyuGram Desktop, run the following command from the command line or from PowerShell:

```powershell
choco install ayugram
```

To upgrade AyuGram Desktop, run the following command from the command line or from PowerShell:

```powershell
choco upgrade ayugram
```

To uninstall AyuGram Desktop, run the following command from the command line or from PowerShell:

```powershell
choco uninstall ayugram
```

## Description

AyuGram Desktop is a free, open-source desktop client for the Telegram messaging service, forked from Telegram Desktop. It adds extra customization options and a Ghost mode on top of the regular client.

### Package Notes

* AyuGram is an unofficial third-party client and is not affiliated with Telegram. You sign in with your own Telegram account.
* This package installs the 64-bit portable build into the Chocolatey tools folder and adds an `AyuGram` Start menu shortcut.
* Like the official portable Telegram build, AyuGram keeps its data (sign-in, settings and cache) in a `tdata` folder next to the program. Package upgrades keep that folder. Uninstalling can leave some of it behind in the package's tools folder (`C:\ProgramData\chocolatey\lib\ayugram`); delete that folder afterwards to remove the data completely.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/ayugram)

[Software Site](https://github.com/AyuGram/AyuGramDesktop)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/ayugram)
