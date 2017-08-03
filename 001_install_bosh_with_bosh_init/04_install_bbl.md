# Install BOSH Bootloader

```exec
BBL_URL="https://github.com/cloudfoundry/bosh-bootloader/releases/download/v4.0.0/bbl-v4.0.0_linux_x86-64"
wget $BBL_URL

chmod +x bbl-v4.0.0_linux_x86-64
sudo mv bbl-v4.0.0_linux_x86-64 /usr/local/bin/bbl

bbl --version
```

Result

```
bbl 4.0.0 (linux/amd64)
```
