## Verify deployment

##### 1. To verify your Cloud Foundry deployment, run smoke tests:

```exec
bosh run errand smoke_tests
```

##### 2. Then, install the CF CLI:

```exec
curl -o cf_cli.deb -J -L 'https://cli.run.pivotal.io/stable?release=debian64&version=6.21.1&source=github-rel'
sudo dpkg -i cf_cli.deb
```

##### 3. Login to Cloud Foundry to see that your deployment is successfully working:

```exec
cf login --skip-ssl-validation -a api.{{source ~/deployment/vars &&  echo $cf_eip}}.nip.io -u admin -p admin
```
