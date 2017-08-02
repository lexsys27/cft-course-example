### Install the BOSH CLI

The [BOSH Command Line Interface (CLI)](https://bosh.io/docs/cli-v2.html) is used to interact with the [BOSH Director] (https://bosh.io/docs/bosh-components.html). The Director is the core orchestrating component in BOSH. The Director controls VM creation and deployment, as well as other software and service lifecycle events. Apart from regular interaction with the Director, BOSH CLI is also used to create and update a BOSH Director VM (and its persistent disk) in an environment. 

The BOSH CLI is written in Ruby and is distributed via the `bosh_cli` gem.

##### 1. Install the `bosh_cli` gem with:

```exec
sudo gem install bosh_cli --no-ri --no-rdoc --no-user-install
```
##### 2.  Verify that the `bosh` command is properly installed:

```exec
bosh -v
```
In this training we use BOSH CLI v1. 
