### Deploy BOSH 

#### 1. In order to run a BOSH deployment, you have to navigate to the `cd ~/deployment` directory and then execute the following command:
  
```exec
bosh-init deploy ~/deployment/bosh.yml
```
Deployment of BOSH will take a while, so you can have a quick coffee break. 

##### NOTE: Whitespace indentation is used to denote structure in `.yaml` files, however tab characters are never allowed as indentation. Most of the errors, which appear during the deployment are related to incorrect indentation. It is strongly recommended to review your manifest prior to running the deployment. 

#### 2. When BOSH is deployed successfully, connect to the BOSH Director:

```exec
bosh -n target {{source deployment/vars && echo $eip}}

bosh login admin admin
```
Credentials are: `admin / admin`



