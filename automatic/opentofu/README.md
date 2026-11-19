# <img src="https://cdn.jsdelivr.net/gh/virtualex-itv/chocolatey-packages@35e0900e78e17030a2787e3d6d85592b84a6a712/icons/opentofu.png" width="48" height="48"/> [opentofu](https://community.chocolatey.org/packages/opentofu)

OpenTofu is an OSS tool for building, changing, and versioning infrastructure safely and efficiently. OpenTofu can manage existing and popular service providers as well as custom in-house solutions.

### Features

* **Infrastructure as Code**: Infrastructure is described using a high-level configuration syntax. This allows a blueprint of your datacenter to be versioned and treated as you would any other code. Additionally, infrastructure can be shared and re-used.
* **Execution Plans**: OpenTofu has a "planning" step where it generates an execution plan. The execution plan shows what OpenTofu will do when you call apply. This lets you avoid any surprises when OpenTofu manipulates infrastructure.
* **Resource Graph**: OpenTofu builds a graph of all your resources, and parallelizes the creation and modification of any non-dependent resources. Because of this, OpenTofu builds infrastructure as efficiently as possible, and operators get insight into dependencies in their infrastructure.
* **Change Automation**: Complex changesets can be applied to your infrastructure with minimal human interaction. With the previously mentioned execution plan and resource graph, you know exactly what OpenTofu will change and in what order, avoiding many possible human errors.

### Package Notes

* This is a meta package that installs [opentofu.portable](https://community.chocolatey.org/packages/opentofu.portable) at the same version.

**Please Note**: This is an automatically updated package. If you find it is out of date by more than a day or two, please contact the maintainer(s) and let them know the package is no longer updating correctly.
