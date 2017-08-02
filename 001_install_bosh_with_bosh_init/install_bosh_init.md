### Install [bosh-init](https://github.com/cloudfoundry/bosh-init)

`bosh-init` is used to create and update a BOSH Director VM (and its persistent disk) in an environment.

#### 1. First of all, we need to download the binary for your platform and place it on your $PATH. Below there are commands used for Linux machines:

```exec
curl https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-0.0.100-linux-amd64 -o bosh-init
  
sudo install -m0755 bosh-init /usr/local/bin/bosh-init
  
rm bosh-init
```

#### 2. After that, we have to make sure that `bosh-init` is properly installed by running the following command
```
bosh-init -v
```

#### 3. For further work with bosh-init and tools like BOSH CLI, we need to install some additional packages:
```exec
sudo apt-get update
  
sudo apt-get install -y python  python-pip unzip build-essential zlibc zlib1g-dev ruby-dev openssl libxslt-dev libxslt1-dev libpq-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 software-properties-common libmysqlclient-dev ruby
```

#### 4. Verify that Ruby 2+ is installed and added to your $PATH:
```
ruby --version
```



