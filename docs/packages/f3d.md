# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@c99606df87a40f5a050407ceaf6cf1290298080b/icons/f3d.png" width="32" height="32"/> [![F3D](https://img.shields.io/chocolatey/v/f3d.svg?label=F3D)](https://community.chocolatey.org/packages/f3d) [![F3D](https://img.shields.io/chocolatey/dt/f3d.svg)](https://community.chocolatey.org/packages/f3d)

## Usage

To install F3D, run the following command from the command line or from PowerShell:

```powershell
choco install f3d
```

To upgrade F3D, run the following command from the command line or from PowerShell:

```powershell
choco upgrade f3d
```

To uninstall F3D, run the following command from the command line or from PowerShell:

```powershell
choco uninstall f3d
```

## Description

F3D (pronounced "fed") is a fast and minimalist 3D viewer. It supports many file formats, from digital content to scientific datasets, can show animations, and offers many rendering and texturing options, including real-time physically based rendering. It is also controllable from the command line.

### Features

* Opens glTF, USD, STL, PLY, OBJ, FBX, 3DS, STEP, IGES, VTK and many other formats
* Plays animations and supports PBR, HDRI environments, and texturing options
* Fully configurable from the command line and configuration files
* Generates thumbnails for supported files in Windows Explorer

### Package Notes

* This package installs the standard 64-bit installer by default.
* The installer does not add F3D to the PATH, so this package creates the `f3d` command (the viewer) and the `f3d-console` command (the console build, which prints to the terminal).

### Package Parameters

* `/Raytracing` - installs the larger build that includes raytracing support instead of the standard build. To switch builds on an existing install, reinstall with `choco install f3d --force --params "'/Raytracing'"`.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/f3d)

[Software Site](https://f3d.app/)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/f3d)
