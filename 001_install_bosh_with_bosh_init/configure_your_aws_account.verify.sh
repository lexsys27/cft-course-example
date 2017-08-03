#!/bin/bash -e

source deployment/vars
check 'echo $vpc_id' 'vpc.*' true #> vpc_id variable should be set
source deployment/vars
check 'echo $subnet_id' 'subnet.*' true #> subnet_id variable should be set
source deployment/vars
check 'echo $gateway_id' 'igw.*' true #> gateway_id variable should be set
source deployment/vars
check 'echo $route_table_id' 'rtb.*' true #> route_table_id variable should be set
source deployment/vars
check 'echo $sg_id' 'sg.*' true #> sg_id variable should be set
source deployment/vars
check 'echo $eip_id' 'eipalloc.*' true #> eip_id variable should be set
source deployment/vars
check 'echo $eip' '^$' false #> eip variable should be set
source deployment/vars
check 'echo $avz' '^$' false #> avz variable should be set
check 'cat deployment/bosh.pem' '-----BEGIN RSA PRIVATE KEY-----.*' true #> deployment/key.pem file should contain AWS private key
