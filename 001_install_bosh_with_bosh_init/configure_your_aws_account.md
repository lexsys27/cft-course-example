### Configure Your AWS Account

There are several options to configure an AWS account for a BOSH deployment - using [AWS web interface](https://bosh.io/docs/init-aws.html) or manually via CLI. Below we provide an explanation on how to manually configure your AWS account for BOSH:

##### 1. First of all, we need to create a Virtual Private Cloud. 

[Amazon Virtual Private Cloud (Amazon VPC)](https://aws.amazon.com/vpc/) allows you to provision a logically isolated section of the Amazon Web Services (AWS) cloud, where you can launch AWS resources in a virtual network that you define.:

```exec
vpc_id=$(aws ec2 create-vpc --cidr-block '10.0.0.0/16' --query 'Vpc.VpcId' --output text)
  
aws ec2 create-tags --resources $vpc_id --tags Key=Name,Value=training_vpc
```

##### 2. Create a [Subnet](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html). 

After creating a VPC, we can add one or more subnets in each Availability Zone (AVZ). When we create a subnet, we specify the Classless Inter-Domain routing (CIDR) block for the subnet, which is a subset of the VPC CIDR block. Each subnet must reside entirely within one Availability Zone and cannot span zones. Availability Zones are distinct locations that are engineered to be isolated from failures in other Availability Zones. Each subnet gets a unique ID:

```exec
subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.0.0/24 --query 'Subnet.SubnetId' --output text)

aws ec2 modify-subnet-attribute --subnet-id $subnet_id --map-public-ip-on-launch
  
aws ec2 create-tags --resources $subnet_id --tags Key=Name,Value=training_subnet
  
avz=$(aws ec2 describe-subnets --subnet-ids $subnet_id --query 'Subnets[].AvailabilityZone' --output text)
```

##### 3. Create an [Internet Gateway](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Internet_Gateway.html) and attach it to the VPC.

An Internet gateway is a horizontally scaled, redundant, and highly available VPC component that allows for communication between instances in your VPC and the Internet. It, therefore, imposes no availability risks or bandwidth constraints on your network traffic.

An Internet gateway serves two purposes: to provide a target in your VPC route tables for Internet-routable traffic, and to perform network address translation (NAT) for instances that have been assigned public IPv4 addresses.

```exec
gateway_id=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
  
aws ec2 create-tags --resources $gateway_id --tags Key=Name,Value=training_gateway
  
aws ec2 attach-internet-gateway --internet-gateway-id $gateway_id --vpc-id $vpc_id
```

##### 4. Create a [Route Table](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Route_Tables.html) and associate it with the Subnet.

A route table contains a set of rules, called routes, that are used to determine where network traffic is directed.

Each subnet in your VPC must be associated with a route table; the table controls the routing for the subnet. A subnet can only be associated with one route table at a time, but you can associate multiple subnets with the same route table.

```exec
route_table_id=$(aws ec2 create-route-table --vpc-id $vpc_id --query 'RouteTable.RouteTableId' --output text)
  
aws ec2 create-tags --resources $route_table_id --tags Key=Name,Value=training_route_table
  
aws ec2 associate-route-table --route-table-id $route_table_id --subnet-id $subnet_id
```

##### 5. Create a Route that will forward all external traffic from the Subnet to the Internet Gateway:
```exec
aws ec2 create-route --gateway-id $gateway_id --route-table-id $route_table_id --destination-cidr-block 0.0.0.0/0
```

##### 6. Create a [Security Group](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html). 

A security group acts as a virtual firewall for your instance to control inbound and outbound traffic. When you launch an instance in a VPC, you can assign the instance to up to five security groups. Security groups act at the instance level, not the subnet level. Therefore, each instance in a subnet in your VPC could be assigned to a different set of security groups. If you don't specify a particular group at launch time, the instance will be automatically assigned to the default security group for the VPC.

```exec
sg_id=$(aws ec2 create-security-group --vpc-id $vpc_id --group-name bosh --description "Security Group bog BOSH deployment" --query 'GroupId' --output text)
  
aws ec2 create-tags --resources $sg_id --tags Key=Name,Value=bosh
```

##### 7. Add Security Group rules

For each security group, we add rules that control the inbound traffic to instances, and a separate set of rules that control the outbound traffic. 

 * Allow ICMP traffic:
```exec
aws ec2 authorize-security-group-ingress --group-id $sg_id --ip-permissions '[{"IpProtocol": "icmp", "FromPort": -1, "ToPort": -1, "IpRanges": [{"CidrIp": "0.0.0.0/0"}]}]'
```

 * Allow SSH access:
```exec
aws ec2 authorize-security-group-ingress --group-id $sg_id --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 22, "ToPort": 22, "IpRanges": [{"CidrIp": "0.0.0.0/0"}]}]'
```

 * Allow `bosh-init` to access BOSH Agent:
```exec
aws ec2 authorize-security-group-ingress --group-id $sg_id --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 6868, "ToPort": 6868, "IpRanges": [{"CidrIp": "0.0.0.0/0"}]}]'
```

 * Allow the BOSH CLI to access BOSH Director:
```exec
aws ec2 authorize-security-group-ingress --group-id $sg_id --ip-permissions '[{"IpProtocol": "tcp", "FromPort": 25555, "ToPort": 25555, "IpRanges": [{"CidrIp": "0.0.0.0/0"}]}]'
```

 * Allow all TCP and UDP traffic inside the security group:
```exec
aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol '-1' --port -1 --source-group $sg_id
 ```

#### 8. Create an [Elastic IP](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html).

An Elastic IP address is a static, public IPv4 address designed for dynamic cloud computing. Elastic IP address could be associated with any instance or network interface for any VPC in your account. With an Elastic IP address, you can mask the failure of an instance by rapidly remapping the address to another instance in your VPC.

```exec
eip_id=$(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)
  
eip=$(aws ec2 describe-addresses --allocation-ids $eip_id --query 'Addresses[].PublicIp' --output text)
```

#### 9. Create a [Key Pair](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html). 

Amazon EC2 uses public–key cryptography to encrypt and decrypt login information. Public–key cryptography uses a public key to encrypt a piece of data, such as a password, then the recipient uses the private key to decrypt the data. The public and private keys are known as a key pair.

To log in to your instance, you must create a key pair, specify its name when you launch the instance, and provide the private key when you connect to the instance. Linux instances have no password, and you use a key pair to log in using SSH. 

```exec
key_name=$(hostname)-training_key
mkdir deployment
aws ec2 create-key-pair --key-name $key_name --query 'KeyMaterial' --output text > deployment/bosh.pem
chmod 400 deployment/bosh.pem
```
#### 10. Finally, we have to store all the variables in a 'vars' file for our deployment manifest:

```exec
cat > ~/deployment/vars <<EOF
export vpc_id=$vpc_id
export subnet_id=$subnet_id
export gateway_id=$gateway_id
export route_table_id=$route_table_id
export sg_id=$sg_id
export eip_id=$eip_id
export eip=$eip
export avz=$avz
export key_name=$key_name
EOF

chmod +x deployment/vars
```


