## Install [spiff](https://github.com/cloudfoundry-incubator/spiff)

Next, you need to install **spiff**. It is a command line tool and declarative YAML templating system, specially designed for generating BOSH deployment manifests. You will need it later to merge templates and create deployment manifest.

##### 1. Download spiff binary and install it locally.

```exec
wget https://github.com/cloudfoundry-incubator/spiff/releases/download/v1.0.7/spiff_linux_amd64
sudo install -m0755 spiff_linux_amd64 /usr/local/bin/spiff
rm spiff_linux_amd64
```

##### 2. Verify spiff installation.

```exec
spiff -v
```
