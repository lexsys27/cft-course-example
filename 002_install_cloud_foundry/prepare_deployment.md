## Prepare deployment

Default Cloud Foundry installation is pretty large. Even if you reduce the number of instances to their minimum values, the resulting installation will require 18 instances. If you only plan to use your installation for educational or testing purposes, that is definitely an overhead. That's why we are going to use [single-vm-cf](https://github.com/Altoros/single-vm-cf) repository that contains special stubs that allow you to install all CF components to a single vm.

##### 1. Install Git.
```exec
sudo apt-get install git -y
```

##### 2. Clone the `single-vm-cf` repository.

```exec
git clone https://github.com/Altoros/single-vm-cf ~/deployment/single-vm-cf
cd ~/deployment/single-vm-cf
git submodule init
git submodule update
cd ~/deployment/single-vm-cf/cf-release
```
This repository includes standard `cf-release` repository as a submodule. 

##### 3. Save the following file as `~/deployment/single-vm-cf/cf-release/stub.yml`
```
---
meta:
  eip: {{source ~/deployment/vars && echo "$cf_eip"}} 
  system_domain: {{source ~/deployment/vars && echo "$cf_eip"}}.nip.io
  private_ip: 10.0.0.10
  aws:
    availability_zone: {{source ~/deployment/vars && echo "$avz"}}
    subnet_id: {{source ~/deployment/vars && echo "$subnet_id"}}

director_uuid: {{ bosh status --uuid 2>/dev/null }}
networks:
  - name: default 
    subnets:
      - range: 10.0.0.0/24
        reserved:
          - 10.0.0.2 - 10.0.0.9
        static:
          - 10.0.0.10 - 10.0.0.15
        gateway: 10.0.0.1
        dns:
          - 10.0.0.2
        cloud_properties:
          security_groups:
            - cf_training_sg
            - bosh
          subnet: (( meta.aws.subnet_id ))
  - name: vip
    type: vip
```

##### 4. Use `spiff` to merge templates and create deployment manifest.

```exec
root_dir=~/deployment/single-vm-cf/cf-release
single_vm_templates="${root_dir}/templates"
cf_templates="${root_dir}/cf-release/templates"
spiff merge \
  "${cf_templates}/generic-manifest-mask.yml" \
  "${single_vm_templates}/jobs-single-vm-aws.yml" \
  "${cf_templates}/cf.yml" \
  "${single_vm_templates}/infrastructure-single-vm-aws.yml" \
  "${root_dir}/stub.yml" >  ~/deployment/single-vm-cf/cf-release/manifest.yml
```
