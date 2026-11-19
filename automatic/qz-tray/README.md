# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@19f4915e69be4508024a888d47a4b2ddd004968a/icons/qz-tray.png" width="48" height="48"/> [qz-tray](https://community.chocolatey.org/packages/qz-tray)

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
