# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@c9958c2fc46d8cba68dd64bdb8b5fa67701320d0/icons/mole.png" width="48" height="48"/> [mole](https://community.chocolatey.org/packages/mole)

Mole is a free, open source command line toolkit for keeping a Windows PC tidy. It combines the jobs of a system cleaner, an app uninstaller, a disk usage analyzer and a live system monitor in one terminal command, `mo`.

### Features

* `mo clean` removes caches, logs and temporary files
* `mo uninstall` removes installed apps together with their leftover files
* `mo purge` clears build artifacts from old projects
* `mo optimize` runs system maintenance tasks
* `mo analyze` shows what is using your disk space
* `mo status` shows a live dashboard of CPU, memory, disk and network
* `--dry-run` previews what a command would remove before anything is deleted

### Package Notes

* This package installs the official portable Windows release of the open source CLI. It needs only the Windows PowerShell 5.1 that ships with Windows 10 and 11.
* Chocolatey puts `mo` on your PATH, and `mole` works as an alias for it.
* 64-bit Windows only.
* `mo update` does not update this copy; update it with `choco upgrade mole`.
* The separate, proprietary Mole for Windows desktop app from mole.fit is not part of this package.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.
