# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@9a6560eaa24462ac56527b420084db8aaa7502e7/icons/bandwhich.png" width="32" height="32"/> [![bandwhich](https://img.shields.io/chocolatey/v/bandwhich.svg?label=bandwhich)](https://community.chocolatey.org/packages/bandwhich) [![bandwhich](https://img.shields.io/chocolatey/dt/bandwhich.svg)](https://community.chocolatey.org/packages/bandwhich)

## Usage

To install bandwhich, run the following command from the command line or from PowerShell:

```powershell
choco install bandwhich
```

To upgrade bandwhich, run the following command from the command line or from PowerShell:

```powershell
choco upgrade bandwhich
```

To uninstall bandwhich, run the following command from the command line or from PowerShell:

```powershell
choco uninstall bandwhich
```

## Description

bandwhich is a command-line tool that sniffs a network interface and shows current network utilization by process, connection and remote IP or hostname. It cross-references packets with the processes that own them using the Windows API and resolves IP addresses to hostnames in the background.

### Features

* Live bandwidth usage per process, connection and remote address
* Responsive terminal interface that adapts to the window size
* Raw, interactive and total-usage output modes

### Package Notes

* This package installs the 64-bit build and puts bandwhich on the PATH.
* bandwhich needs Npcap to capture packets on Windows. Npcap is not installed by this package because its free edition does not support silent installation; install it from https://npcap.com/#download (enable WinPcap API-compatible mode).
* Run bandwhich from an elevated terminal.
* The project is in passive maintenance; the latest release is from October 2024.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/bandwhich)

[Software Site](https://github.com/imsnif/bandwhich)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/bandwhich)
