## Deploy

Deploying Cloud Foundry with BOSH requires 3 easy steps.

##### 1. First, we need to upload a stemcell. 

It is a versioned image of a bare-minimum OS skeleton, wrapped with IaaS-specific packaging. Deploying Cloud Foundry starts with specifying a stemcell, which BOSH installs on each component VM. To do that, run:

```exec
bosh upload stemcell https://bosh.io/d/stemcells/bosh-aws-xen-hvm-ubuntu-trusty-go_agent
```

##### 2. Then, upload the Cloud Foundry release.

```exec
bosh upload release https://bosh.io/d/github.com/cloudfoundry/cf-release?v=252
```

##### 3. At last, start deployment and have a coffee.
  
```exec
bosh deployment ~/deployment/single-vm-cf/cf-release/manifest.yml

bosh deploy
```
