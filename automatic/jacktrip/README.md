# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@7e2d89741cc5afc137ec17925ff8a19e10855572/icons/jacktrip.png" width="48" height="48"/> [jacktrip](https://community.chocolatey.org/packages/jacktrip)

JackTrip is a multi-machine audio system used for network music performance over the Internet. It streams bidirectional, high-quality, uncompressed audio between computers, and it started in the SoundWIRE group at Stanford University's CCRMA.

### Features

* Bidirectional, uncompressed audio streaming with as many channels as the computer and network can handle
* Works between any mix of Windows, macOS, Linux and FreeBSD machines
* Classic mode graphical interface and a command line (`jacktrip`) for scripted use
* Windows builds can use ASIO drivers (ASIO is a trademark of Steinberg Media Technologies GmbH)

### Package Notes

* This package installs the 64-bit MSI published by the JackTrip project on GitHub, which includes the Classic mode graphical interface. The separately signed installer from JackTrip Labs leaves that interface out and is not used.
* The MSI is not code signed, so Windows SmartScreen may warn if it is downloaded by hand. Chocolatey verifies the SHA-256 checksum of the download instead.
* JackTrip needs the Microsoft Visual C++ Redistributable, which is installed as a dependency.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.
