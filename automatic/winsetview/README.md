# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@b3fa31a89255b2f85e4fbd3bcff611cbc1088832/icons/winsetview.png" width="48" height="48"/> [winsetview](https://community.chocolatey.org/packages/winsetview)

WinSetView sets your preferred Windows Explorer folder views for every folder type, not just the basic five, and applies many other Explorer options with one click. The views are stored in a copy of the FolderTypes registry key that Windows updates do not overwrite, and the changes can be backed up and restored. It can also be driven from the command line.

### Package Notes

* This package installs the setup program from the project. All changes WinSetView makes are per user, so run it once for each user account that should get the new folder views.
* WinSetView needs .NET Framework 4.8, which is installed as a dependency where it is not already present.
* Some security software reports WinSetView as potentially unwanted because it launches a PowerShell script that changes Explorer settings.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.
