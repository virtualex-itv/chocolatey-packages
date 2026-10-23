# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@8965fb7d114c4444bb17ed739693cdb4968a48ba/icons/cardinal.png" width="32" height="32"/> [![Cardinal](https://img.shields.io/chocolatey/v/cardinal.svg?label=Cardinal)](https://community.chocolatey.org/packages/cardinal) [![Cardinal](https://img.shields.io/chocolatey/dt/cardinal.svg)](https://community.chocolatey.org/packages/cardinal)

## Usage

To install Cardinal, run the following command from the command line or from PowerShell:

```powershell
choco install cardinal
```

To upgrade Cardinal, run the following command from the command line or from PowerShell:

```powershell
choco upgrade cardinal
```

To uninstall Cardinal, run the following command from the command line or from PowerShell:

```powershell
choco uninstall cardinal
```

## Description

Cardinal is a free and open-source virtual modular synthesizer plugin, based on VCV Rack. Its goal is a self-contained, fully free and open-source plugin version of Rack, and it bundles a large collection of modules.

### Features

* Plugin formats on Windows: CLAP, LV2, VST2 and VST3 (instrument, effect and synth variants)
* Carla and Ildaeil host tools for loading other plugins inside a patch
* An optional standalone app

### Package Notes

* This package installs the 64-bit installer with the vendor's "Full installation" components: Carla/Ildaeil host tools plus the LV2, VST2, VST3 and CLAP plugins. The standalone app is not part of that selection.
* Add the standalone (native) app with the package parameter `/Standalone`: `choco install cardinal --params "'/Standalone'"`.
* The download is large (about 370 MB).

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/cardinal)

[Software Site](https://cardinal.kx.studio/)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/cardinal)
