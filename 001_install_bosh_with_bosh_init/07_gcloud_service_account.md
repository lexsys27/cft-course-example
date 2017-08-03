# Create service account in Google cloud

```exec
  BBL_SERVICE_ACCOUNT=bbl-cf
  BBL_PROJECT_ID=<  Your google cloud project name >

  gcloud iam service-accounts create $BBL_SERVICE_ACCOUNT
  gcloud iam service-accounts keys create \
    --iam-account="$BBL_SERVICE_ACCOUNT@$BBL_PROJECT_ID.iam.gserviceaccount.com" \
    $BBL_SERVICE_ACCOUNT.key.json

  BBL_MEMBER=serviceAccount:$BBL_SERVICE_ACCOUNT@$BBL_PROJECT_ID.iam.gserviceaccount.com

  gcloud projects add-iam-policy-binding $BBL_PROJECT_ID \
    --member=$BBL_MEMBER \
    --role='roles/editor'
```
