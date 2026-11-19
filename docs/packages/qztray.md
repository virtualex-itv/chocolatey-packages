# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@19f4915e69be4508024a888d47a4b2ddd004968a/icons/qz-tray.png" width="32" height="32"/> [![QZ Tray](https://img.shields.io/chocolatey/v/qz-tray.svg?label=QZ+Tray)](https://community.chocolatey.org/packages/qz-tray) [![QZ Tray](https://img.shields.io/chocolatey/dt/qz-tray.svg)](https://community.chocolatey.org/packages/qz-tray)

## Usage

To install QZ Tray, run the following command from the command line or from PowerShell:

```powershell
choco install qz-tray
```

To upgrade QZ Tray, run the following command from the command line or from PowerShell:

```powershell
choco upgrade qz-tray
```

To uninstall QZ Tray, run the following command from the command line or from PowerShell:

```powershell
choco uninstall qz-tray
```

## Description

QZ Tray is a cross-browser, cross-platform application that lets a web page print documents and send raw commands (such as ZPL, EPL or ESC/POS) to printers and other attached devices such as serial ports, USB and HID devices. Web pages talk to it through a local secure WebSocket and the qz-tray.js JavaScript library.

### Features

* Print HTML, PDF and images to any installed printer
* Send raw commands to label, barcode and receipt printers
* Communicate with serial, USB, HID and network devices from the browser
* Works with all modern browsers

### Package Notes

* The installer bundles its own Java runtime, so no separate Java install is needed.
* The installer adds a startup entry for all users, a Windows Firewall rule and a local certificate for the secure WebSocket, and starts QZ Tray when it finishes. Uninstalling removes them.
* The 64-bit build is installed on x64 Windows and the native ARM64 build on ARM64 Windows. There is no 32-bit Windows build.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/qz-tray)

[Software Site](https://qz.io/)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/qz-tray)
