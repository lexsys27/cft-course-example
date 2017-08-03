# Install bosh cli

Download latest release from `Releases` 
[page](https://github.com/cloudfoundry/bosh-cli/releases).

```exec
BOSH_CLI="https://s3.amazonaws.com/bosh-cli-artifacts/bosh-cli-2.0.28-linux-amd64"
wget $BOSH_CLI
chmod +x bosh-cli-2.0.28-linux-amd64
sudo mv bosh-cli-2.0.28-linux-amd64 /usr/local/bin/bosh

bosh --version
```

The result should be

```
$ bosh --version
version 2.0.28-cb77557-2017-07-11T23:04:21Z

Succeeded
```

