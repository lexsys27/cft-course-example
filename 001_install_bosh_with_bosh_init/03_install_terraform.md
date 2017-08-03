# Install Terraform

```exec
TERRAFORM_URL="https://releases.hashicorp.com/terraform/0.10.0/terraform_0.10.0_linux_amd64.zip"
wget $TERRAFORM_URL
unzip terraform_0.10.0_linux_amd64.zip
sudo mv terraform /usr/local/bin

terraform version
```

Output

```
Terraform v0.10.0
```
