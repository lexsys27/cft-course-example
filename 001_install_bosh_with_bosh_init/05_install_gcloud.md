# Installing Google Cloud SDK

```exec
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install -y google-cloud-sdk

gcloud --version
```

Output

```
Google Cloud SDK 165.0.0
alpha 2017.07.28
beta 2017.07.28
bq 2.0.25
core 2017.07.28
gcloud
gsutil 4.27
```
