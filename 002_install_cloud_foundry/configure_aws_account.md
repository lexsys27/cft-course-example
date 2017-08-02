### Configure your AWS account

Before deploying Cloud Foundry, first of all, you need to configure your infrastructure. The following steps will guide you through necessary configurations for your AWS account, so that you can prepare it for the Cloud Foundry deployment.

##### 1. Add a rule to allow Loggregator traffic
Loggregator provides a highly-available (HA) and secure stream of logs and metrics for all applications and components on Cloud Foundry:

```exec
source ~/deployment/vars

aws ec2 authorize-security-group-ingress --group-id $sg_id --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 4443, "ToPort": 4443, "IpRanges": [{"CidrIp": "0.0.0.0/0"}]}]'
```
##### 2. Create a Security Group:
```exec
cf_sg_id=$(aws ec2 create-security-group --vpc-id $vpc_id --group-name cf_training_sg --description "Security Group for CF deployment" --query 'GroupId' --output text)

aws ec2 create-tags --resources $cf_sg_id --tags Key=Name,Value=cf_training_sg
```

##### 3. Add Security Group rules:
  * Allow HTTP traffic
    
```exec
aws ec2 authorize-security-group-ingress --group-id $cf_sg_id --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 80, "ToPort": 80, "IpRanges": [{"CidrIp": "0.0.0.0/0"}]}]'
```

  * Allow HTTPS traffic:
    
```exec
aws ec2 authorize-security-group-ingress --group-id $cf_sg_id --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 443, "ToPort": 443, "IpRanges": [{"CidrIp": "0.0.0.0/0"}]}]'
```

  * Allow Loggregator traffic:
    
```exec
aws ec2 authorize-security-group-ingress --group-id $cf_sg_id --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 4443, "ToPort": 4443, "IpRanges": [{"CidrIp": "0.0.0.0/0"}]}]'
```

##### 4. Create an Elastic IP:

```exec
cf_eip_id=$(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)
cf_eip=$(aws ec2 describe-addresses --allocation-ids $cf_eip_id --query 'Addresses[].PublicIp' --output text)
```

##### 5. Store all variables in a file for later use:

```exec
cat >> ~/deployment/vars <<EOF
export cf_eip_id=$cf_eip_id
export cf_eip=$cf_eip
export cf_sg_id=$cf_sg_id
EOF
```
