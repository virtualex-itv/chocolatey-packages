# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@69ec6737877e129294ab3ba2b2029b744f094ed2/icons/notepadreplacer.png" width="48" height="48"/> [notepadreplacer](https://community.chocolatey.org/packages/notepadreplacer)

## Package Parameters

* **If the parameter is not specified, the installation will fail and exit**
* `/NOTEPAD` - Specifies the path to the executable for the program you wish to replace Notepad with.
Example:

```shell
choco install notepadreplacer --params='"/NOTEPAD:C:\Program Files\Notepad++\notepad++.exe"'
```

To have choco remember parameters on upgrade, be sure to set:

```shell
choco feature enable -n=useRememberedArgumentsForUpgrades`
```

---

## Overview of Notepad Replacer

Do you use a Notepad alternative, like Notepad++ or Notepad2? Notepad Replacer will allow you to replace the default Windows version of Notepad with whatever alternative you would like to use. No System Files Replaced Won't replace ANY system files, or change ANY file permissions.

* **No System Files Replaced**
* **No Background Processes**
* **No Security Warnings**
* **Completely Free**

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.
