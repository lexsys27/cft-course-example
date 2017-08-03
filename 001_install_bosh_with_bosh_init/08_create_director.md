# Create BOSH Director

```exec
  bbl up \
    --gcp-zone europe-west1-b \
    --gcp-region europe-west1 \
    --gcp-service-account-key $BBL_SERVICE_ACCOUNT.key.json \
    --gcp-project-id $BBL_PROJECT_ID \
    --iaas gcp \
    --name bosh
```

Set up BOSH environment

```exec
export BOSH_CLIENT=`bbl director-username`
export BOSH_CLIENT_SECRET=`bbl director-password`
export BOSH_CA_CERT=`bbl director-ca-cert`
export BOSH_ENVIRONMENT=`bbl director-address`
```
