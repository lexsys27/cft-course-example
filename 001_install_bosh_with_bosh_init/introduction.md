### Introduction

[BOSH](http://bosh.io/docs/about.html) is a project that unifies release engineering, deployment, and lifecycle management of small and large-scale cloud software. BOSH can provision and deploy software over numerous VMs. It also performs monitoring, failure recovery, and software updates with zero-to-minimal downtime.

While BOSH was developed to deploy [Cloud Foundry](https://www.cloudfoundry.org/), it can also be used to deploy almost any other software (e.g. services). In  this course, we will use BOSH for installing and configuring Cloud Foundry deployment as well as other important components. But the first thing we are going to do is to install BOSH itself.

### Main BOSH Concepts

BOSH has several concepts that are very important to know and understand. You can say that the main BOSH job is to launch new VMs, configure and manage them. In terms of BOSH these VMS are called `Instances`. `Instances` are combined into `Instance Groups`, which contain same packages and configuration. 

There are three core things, that you need to prepare as an input for BOSH to deploy anything:

`Stemcell` - a basic operating system image wrapped with IaaS specific packaging. A typical stemcell contains a bare minimum OS skeleton with a few common utilities pre-installed, a BOSH Agent, and a few configuration files to securely configure the OS by default. 

Stemcells do not contain any specific information about any software that will be installed once that stemcell becomes a specialized machine in the cluster; nor do they contain any sensitive information which would make them unable to be shared with other BOSH users. This clear separation between base Operating System and later-installed software is what makes stemcells a powerful concept.

Together with that, stemcells for one OS are exactly the same for all infrastructures. This property of stemcells allows BOSH users to quickly and reliably switch between different infrastructures without worrying about the differences between OS images.

`Release` - is a versioned set of packages with source code or binaries of software, that we are going to run on `Instances`. Apart from that, releases also contain configuration properties, configuration templates, start up scripts, and anything else required to build and deploy software in a reproducible way.

A release is the layer placed on top of a stemcell. They are self-contained and provide very specific software for the purpose of that release.

By allowing layering of stemcells and releases, BOSH is able to solve problems such as “how does one make sure that the compiled version of the software is reliably available throughout the deploy”, or “how to version and roll out updated software to the whole cluster, VM-by-VM, that other orchestration software is not able to solve”.

`Manifest` - the main configuration file that provides BOSH with information on instances that we are going to launch.

The deployment manifest is a YAML file that defines the components and properties of the deployment. When engineer initiates a new deployment, the Director receives a version of the deployment manifest and creates a new deployment using this manifest.

##### In a nutshell, stemcell could be considered as an operating system, release as a package and manifest as the main configuration file. The diagram below shows relation between these terms:

<img src="https://s3.amazonaws.com/cf-training-resources/inputs.png" height="400">

BOSH as an another complex tool has its own terminology, we recomend to get acquainted with the necessary vocabulary in [BOSH docs](http://bosh.io/docs/terminology.html).
