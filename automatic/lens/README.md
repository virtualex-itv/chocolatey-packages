# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@1f7b6b334898ed930db76bf701e3b59d3b61faf0/icons/lens.png" width="48" height="48"/> [lens](https://community.chocolatey.org/packages/lens)

Lens is the only IDE you’ll ever need to take control of your Kubernetes clusters.  Lens is open source and free.

* **Note:** By default, this package will install for all users, however, the following parameter is available to install into the current user profile: `/CURRENTUSER`

Example:

```shell
choco install lens --params='"/CURRENTUSER"'
```

To have choco remember parameters on upgrade, be sure to set:

```shell
choco feature enable -n=useRememberedArgumentsForUpgrades
```

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.
