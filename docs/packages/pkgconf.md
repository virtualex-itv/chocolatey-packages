# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@590ab29da42bdedb9c6da1fd355e411f98e4c339/icons/pkgconf.png" width="32" height="32"/> [![pkgconf](https://img.shields.io/chocolatey/v/pkgconf.svg?label=pkgconf)](https://community.chocolatey.org/packages/pkgconf) [![pkgconf](https://img.shields.io/chocolatey/dt/pkgconf.svg)](https://community.chocolatey.org/packages/pkgconf)

## Usage

To install pkgconf, run the following command from the command line or from PowerShell:

```powershell
choco install pkgconf
```

To upgrade pkgconf, run the following command from the command line or from PowerShell:

```powershell
choco upgrade pkgconf
```

To uninstall pkgconf, run the following command from the command line or from PowerShell:

```powershell
choco uninstall pkgconf
```

## Description

pkgconf is a program which helps to configure compiler and linker flags for development libraries. It is a superset of the functionality provided by pkg-config from freedesktop.org, but does not provide bug-compatibility with the original pkg-config. Unlike the original, pkgconf builds a flattened directed dependency graph, which gives more insight into how the libraries a project depends on fit together.

### Features

* `pkgconf` and a `pkg-config` command that behaves the same, so build systems that look for either name find it
* `bomtool` and `spdxtool` generate a software bill of materials (SBOM) for a set of pkg-config modules, in the SPDX 2.0 and SPDX Lite 3.0.1 formats
* `pccritic` checks pkg-config files for common mistakes
* Released under the ISC license

### Package Notes

* The package installs the MSI built by the project for your processor: 64-bit, 32-bit or ARM64.
* The installer adds its folder to the system PATH. Open a new terminal after installing so the commands are found.
* The package installs only the command line tools. It does not install any `.pc` files; those come with the libraries you build against.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/pkgconf)

[Software Site](https://github.com/pkgconf/pkgconf)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/pkgconf)
