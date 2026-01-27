#  [![[Deprecated] OpenLens](https://img.shields.io/chocolatey/v/openlens.svg?label=%5BDeprecated%5D+OpenLens)](https://community.chocolatey.org/packages/openlens) [![[Deprecated] OpenLens](https://img.shields.io/chocolatey/dt/openlens.svg)](https://community.chocolatey.org/packages/openlens)

## Usage

To install [Deprecated] OpenLens, run the following command from the command line or from PowerShell:

```powershell
choco install openlens
```

To upgrade [Deprecated] OpenLens, run the following command from the command line or from PowerShell:

```powershell
choco upgrade openlens
```

To uninstall [Deprecated] OpenLens, run the following command from the command line or from PowerShell:

```powershell
choco uninstall openlens
```

## Description

## DEPRECATED

OpenLens has been deprecated because the project is **discontinued**.

In early 2024, Mirantis removed the public source code for Lens, making it impossible to build new OpenLens releases. The last OpenLens release (v6.5.2-366) was in June 2023.

**[Freelens](https://github.com/freelensapp/freelens)** is an active open-source fork created by community contributors to continue the OpenLens vision with modern Kubernetes support and long-term maintenance.

### What happens when you install this package?

This deprecated package will automatically install the replacement package **[freelens](https://community.chocolatey.org/packages/freelens)** as a dependency.

---

### Migration

To migrate manually:
```powershell
choco uninstall openlens
choco install freelens
```

Or simply update, and the dependency will handle the transition:
```powershell
choco upgrade openlens
```


## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/openlens)

[Software Site](https://github.com/freelensapp/freelens)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/deprecated/openlens)

