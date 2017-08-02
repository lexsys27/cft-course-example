### Prepare a deployment manifest

Now we need to prepare a deployment manifest. The manifest should be stored as `~/deployment/bosh.yml`.  It is a `yml` file that should contain the following top level sections.

##### 1. [Deployment identification](https://bosh.io/docs/deployment-manifest.html#deployment)

````file=~/deployment/bosh.yml
---
name: bosh

```
 Note, that in our case this block doesn't contain `director_uuid` parameter, because we are creating environment and don't have BOSH Director installed yet.

#### 2. [Releases block](https://bosh.io/docs/deployment-manifest.html#releases)

```file+=~/deployment/bosh.yml

releases:
- name: bosh
  url: https://bosh.io/d/github.com/cloudfoundry/bosh?v=256.2
  sha1: ff2f4e16e02f66b31c595196052a809100cfd5a8
- name: bosh-aws-cpi
  url: https://bosh.io/d/github.com/cloudfoundry-incubator/bosh-aws-cpi-release?v=52
  sha1: dc4a0cca3b33dce291e4fbeb9e9948b6a7be3324

```
This section contains information about the releases that we are going to use in the deployment. As you can see, we are installing `bosh` and `bosh-aws-cpi` releases. A Cloud Provider Interface (CPI) is an API that the Director uses to interact with an IaaS. The CPI abstracts infrastructure differences from the rest of BOSH. Note, that we are using our precompiled releases here to speed up the deployment.

##### 3. [Resource Pools Block](https://bosh.io/docs/deployment-manifest.html#resource-pools)

```file+=~/deployment/bosh.yml
resource_pools:
- name: vms
  network: private
  stemcell:
    url: https://bosh.io/d/stemcells/bosh-aws-xen-hvm-ubuntu-trusty-go_agent?v=3012
    sha1: 3380b55948abe4c437dee97f67d2d8df4eec3fc1
  cloud_properties:
    instance_type: t2.medium
    ephemeral_disk: {size: 25_000, type: gp2}
    availability_zone: {{source deployment/vars && echo $avz}} # <--- Replace with Availability Zone
    
```
Here, we define what type of vms we are going to create in our deployment. Also we provide information about the [stemcell](https://bosh.cloudfoundry.org/docs/stemcell.html) that will be used and will define some AWS specific properties, like `availability_zone`,  `instance_type` and `ephemeral_disk`. `ephemeral_disk` is the size of [Instance store](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html) disk that will be attached to the VM. It is important, because all non persistent information (like bosh jobs, packages, logs) will be stored here. 

##### 4. [Disk Pools Block](https://bosh.io/docs/deployment-manifest.html#disk-pools) 

```file+=~/deployment/bosh.yml

disk_pools:
- name: disks
  disk_size: 20_000
  cloud_properties: {type: gp2}
```
This section defines the size of persistent disk, that will be attached to our BOSH VM. Data from BOSH database will be stored here.

##### 5. [Networks Block](https://bosh.io/docs/deployment-manifest.html#networks)

```file+=~/deployment/bosh.yml

networks:
- name: private
  type: manual
  subnets:
  - range: 10.0.0.0/24
    gateway: 10.0.0.1
    dns: [10.0.0.2]
    cloud_properties: {subnet: {{source deployment/vars && echo $subnet_id}} } # <--- Replace with Subnet ID
- name: public
  type: vip

```
Here, we define 2 networks. The first one has [manual](https://bosh.io/docs/networks.html#manual) type. This means that for all VMs that use this network we need to hardcode their IP addresses in the manifest. The second one is [vip](https://bosh.io/docs/networks.html#vip) that is used to assign [Elastic IP Addresses](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-eips.html) to a VM.

##### 6. [Jobs Block](https://bosh.io/docs/deployment-manifest.html#jobs) 

```file+=~/deployment/bosh.yml
  
jobs:
- name: bosh
  instances: 1
  
  ```
Here, we actually configure a VM that is going to be created. As you can see, we just reference properties, defined in different blocks. `jobs` section also contain a few other subsections defined below. (In yml, object nesting is defined by indentation. The following blocks already have correct indentation, so you just need to copy them after `jobs` section )
  
##### 7. Templates  
  
```file+=~/deployment/bosh.yml

  templates:
  - {name: nats, release: bosh}
  - {name: postgres, release: bosh}
  - {name: blobstore, release: bosh}
  - {name: director, release: bosh}
  - {name: health_monitor, release: bosh}
  - {name: registry, release: bosh}
  - {name: aws_cpi, release: bosh-aws-cpi}

  resource_pool: vms
  persistent_disk_pool: disks

  
```
 
Each template corresponds to a separate job that will run on a BOSH VM. See [BOSH Components](https://bosh.cloudfoundry.org/docs/bosh-components.html) for more information.

#### 8. Networks
  
```file+=~/deployment/bosh.yml
  networks:
  - name: private
    static_ips: [10.0.0.6]
    default: [dns, gateway]
  - name: public
    static_ips: [{{source deployment/vars && echo $eip}}] # <--- Replace with Elastic IP

 ```
Here, we define that our VM belongs to two networks and specify IP addresses. We also specify that `gateway` and `dns` configuration will be taken from  the `private` network.

##### 9. Properties 
  
```file+=~/deployment/bosh.yml
  properties:
    nats:
      address: 127.0.0.1
      user: nats
      password: nats-password

    postgres: &db
      listen_address: 127.0.0.1
      host: 127.0.0.1
      user: postgres
      password: postgres-password
      database: bosh
      adapter: postgres

    registry:
      address: 10.0.0.6
      host: 10.0.0.6
      db: *db
      http: {user: admin, password: admin, port: 25777}
      username: admin
      password: admin
      port: 25777

    blobstore:
      address: 10.0.0.6
      port: 25250
      provider: dav
      director: {user: director, password: director-password}
      agent: {user: agent, password: agent-password}

    director:
      address: 127.0.0.1
      name: my-bosh
      db: *db
      cpi_job: aws_cpi
      max_threads: 10
      user_management:
        provider: local
        local:
          users:
          - {name: admin, password: admin}
          - {name: hm, password: hm-password}

    hm:
      director_account: {user: hm, password: hm-password}
      resurrector_enabled: true

    aws: &aws
      access_key_id: {{cat ~/.aws/credentials | grep aws_access_key_id | awk '{print $3}'}} # <--- Replace with AWS Access Key ID
      secret_access_key: {{cat ~/.aws/credentials | grep aws_secret_access_key | awk '{print $3}'}} # <--- Replace with AWS Secret Key
      default_key_name: {{source deployment/vars && echo $key_name}}
      default_security_groups: [{{source deployment/vars && echo $sg_id}}]
      region: {{cat ~/.aws/config | grep region | awk '{print $3}'}}  # <--- Replace with Region

    agent: {mbus: "nats://nats:nats-password@10.0.0.6:4222"}

    ntp: &ntp [0.pool.ntp.org, 1.pool.ntp.org]

```
      
This section is the most important, because here we actually configure the jobs that will run on a BOSH VM. Information about meaning of each particular property can be found in the [bosh](http://bosh.io/releases/github.com/cloudfoundry/bosh?version=256.2) and [bosh-aws-cpi](http://bosh.io/releases/github.com/cloudfoundry-incubator/bosh-aws-cpi-release?version=52) release specifications. Note, that the properties are grouped per job.


##### 10. [Cloud Provider Block](https://bosh.io/docs/deployment-manifest.html#cloud-provider)

```file+=~/deployment/bosh.yml

cloud_provider:
  template: {name: aws_cpi, release: bosh-aws-cpi}

  ssh_tunnel:
    host: {{source deployment/vars && echo $eip}} # <--- Replace with your Elastic IP address
    port: 22
    user: vcap
    private_key: ./bosh.pem # Path relative to this manifest file

  mbus: "https://mbus:mbus-password@{{source deployment/vars && echo $eip}}:6868" # <--- Replace with Elastic IP

  properties:
    aws: *aws
    agent: {mbus: "https://mbus:mbus-password@0.0.0.0:6868"}
    blobstore: {provider: local, path: /var/vcap/micro_bosh/data/cache}
    ntp: *ntp

```
This section is specific for `bosh-init` manifests and can't be found in a regular manifest. This section is needed because BOSH CLI first deploys CPI locally and then emulates behaviour of a normal BOSH Director. In order to be able to do this, it also needs to create a ssh tunnel and setup connection with BOSH agent that runs on the deployed VM. [Here](https://github.com/cloudfoundry/bosh-cli/blob/master/docs/cli_workflow.md) you can find for more information about how BOSH CLI initializes an environment.



