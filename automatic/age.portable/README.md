# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@a7f6a36dc0ab5524deb8d6a3e772199ef4c443b3/icons/age.portable.png" width="48" height="48"/> [age.portable](https://community.chocolatey.org/packages/age.portable)

age is a simple, modern and secure file encryption tool, format and Go library. It features small explicit keys, no config options and UNIX-style composability.

### Features

* Encrypt to one or more recipients: native X25519 keys, SSH keys (ssh-rsa and ssh-ed25519) or plugins
* Encrypt with a passphrase
* Small explicit keys and no config options, so there is nothing to misconfigure
* Works in pipes and scripts, in any shell

### Package Notes

* This package installs the portable binaries, which Chocolatey shims onto your PATH: age, age-keygen, age-inspect and the plugin binaries (age-plugin-pq, age-plugin-tag, age-plugin-tagpq, age-plugin-batchpass).
* The 64-bit build is installed on x64 Windows and the native ARM64 build on ARM64 Windows. There is no 32-bit Windows build.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.
