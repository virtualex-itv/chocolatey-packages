# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@c1bd8152008b6456bb0103bd91985692be6dec41/icons/bindplane-otel-collector.png" width="32" height="32"/> [![Bindplane Distro for OpenTelemetry Collector (BDOT)](https://img.shields.io/chocolatey/v/bindplane-otel-collector.svg?label=Bindplane+Distro+for+OpenTelemetry+Collector+(BDOT))](https://community.chocolatey.org/packages/bindplane-otel-collector) [![Bindplane Distro for OpenTelemetry Collector (BDOT)](https://img.shields.io/chocolatey/dt/bindplane-otel-collector.svg)](https://community.chocolatey.org/packages/bindplane-otel-collector)

## Usage

To install Bindplane Distro for OpenTelemetry Collector (BDOT), run the following command from the command line or from PowerShell:

```powershell
choco install bindplane-otel-collector
```

To upgrade Bindplane Distro for OpenTelemetry Collector (BDOT), run the following command from the command line or from PowerShell:

```powershell
choco upgrade bindplane-otel-collector
```

To uninstall Bindplane Distro for OpenTelemetry Collector (BDOT), run the following command from the command line or from PowerShell:

```powershell
choco uninstall bindplane-otel-collector
```

## Description

The Bindplane Distro for OpenTelemetry Collector (BDOT Collector, formerly the observIQ Distro for OpenTelemetry Collector, also called the Bindplane Agent) is Bindplane's distribution of the upstream OpenTelemetry Collector. It was the first distribution to implement the Open Agent Management Protocol (OpAMP), and it is designed to be managed with the Bindplane Telemetry Pipeline, though it also runs standalone from a local configuration file.

### Package Notes

* The MSI installs the collector as the `observiq-otel-collector` Windows service and starts it. The configuration file is `config.yaml` in `C:\Program Files\observIQ OpenTelemetry Collector`; restart the service after changing it. Logs are written to the `log` folder next to it.
* To connect the collector to an OpAMP server (managed mode), pass the installer's properties through Chocolatey, for example: `--install-arguments="'ENABLEMANAGEMENT=1 OPAMPENDPOINT=wss://app.bindplane.com/v1/opamp OPAMPSECRETKEY=your-key OPAMPLABELS=env=prod'"`. `INSTALLDIR` and `CLEAN=1` are also supported.
* On ARM64 Windows the ARM64 MSI is installed; on other 64-bit Windows the x64 MSI.
* New collector versions are released often, so this package follows with frequent updates.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.

## Links

[Chocolatey Package Page](https://community.chocolatey.org/packages/bindplane-otel-collector)

[Software Site](https://bindplane.com)

[Package Source](https://github.com/virtualex-itv/chocolatey-packages/tree/master/automatic/bindplane-otel-collector)
