# Upload stemcell

```exec
  STEMCELL_VERSION="3421.11"
  STEMCELL_URL="https://s3.amazonaws.com/bosh-gce-light-stemcells/light-bosh-stemcell-$STEMCELL_VERSION-google-kvm-ubuntu-trusty-go_agent.tgz"
  bosh upload-stemcell $STEMCELL_URL
```
