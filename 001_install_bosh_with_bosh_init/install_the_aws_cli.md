### Install the AWS CLI

The AWS Command Line Interface (CLI) is a unified tool to manage your AWS services. With just one tool to download and configure, you can control multiple AWS services from the command line and automate them through scripts.

##### 1. Install the AWS CLI:
```exec
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
  
unzip awscli-bundle.zip
  
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
  
rm awscli-bundle* -rf
```

##### 2. Configure the AWS CLI:
```
aws configure
```
Enter your AWS credentials (access and secret keys) and set up the default region. It is recommended to chose `us-west-2` region.
