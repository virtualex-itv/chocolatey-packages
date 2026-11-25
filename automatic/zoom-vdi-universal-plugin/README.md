# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@4bc97ef4b76f848122c82a6fc8383f2f62426f6b/icons/zoom-vdi.png" width="48" height="48"/> [zoom-vdi-universal-plugin](https://community.chocolatey.org/packages/zoom-vdi-universal-plugin)

The Zoom VDI Universal Plugin is installed on the device a user connects to a virtual desktop from. It works with the Zoom VDI client inside the virtual desktop and handles that client's audio and video locally, which gives better call quality and lowers the load on the virtual desktop host. One installer covers the supported remote desktop clients, such as Citrix Workspace app, Omnissa (VMware) Horizon Client, the Microsoft Remote Desktop client for Azure Virtual Desktop, Amazon WorkSpaces and the HP Anyware PCoIP client.

### Package Notes

* Install this package on the devices users connect from. Install [zoom-vdi-client](https://community.chocolatey.org/packages/zoom-vdi-client) in the virtual desktop or on the session host.
* Install the remote desktop client before this package: the plugin installer looks for the installed clients and sets itself up for the ones it finds.
* The VDI client and plugin are released together with the same version. Zoom documents which plugin versions each client version supports.
* Zoom publishes a 64-bit installer only.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.
