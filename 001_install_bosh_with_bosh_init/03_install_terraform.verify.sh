#!/bin/bash -e

check 'terraform version' 'Terraform' true  #> No Terraform binary found
check 'terraform version' '0.10.0' true  #> Incorrect Terraform version

