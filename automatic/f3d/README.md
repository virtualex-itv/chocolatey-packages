# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@c99606df87a40f5a050407ceaf6cf1290298080b/icons/f3d.png" width="48" height="48"/> [f3d](https://community.chocolatey.org/packages/f3d)

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
