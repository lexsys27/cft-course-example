#!/bin/bash

set -e

BBL_SERVICE_ACCOUNT=bbl-cf
BBL_PROJECT_ID=<paste your GCP project ID here>

# The script install all the prerequisites on the Mac OS.
# Tested with macOS 10.12.5

# Install BOSH v2 CLI locally

install_bosh () {
  echo "Installing BOSH v2 CLI..."
  brew tap cloudfoundry/tap
  brew install bosh-cli --without-bosh2

  bosh --version
  echo "BOSH v2 CLI installed"
}

uninstall_bosh () {
  brew untap cloudfoundry/tap
  brew remove bosh-cli
}

# Install Ruby locally

install_ruby () {
  echo "Installing Ruby..."
  brew install ruby
  echo "installed Ruby"
}

uninstall_ruby () {
  brew remove ruby
}

# Install Terraform

install_terraform () {
  echo "Installing Terraform..."
  brew install terraform
  echo "$(terraform version) is installed"
}

uninstall_terraform () {
  brew remove terraform
}

# Install BOSH bootloader

install_bbl () {
  echo "Installing BOSH Bootloader..."
  brew install bbl

  bbl version
  echo "BOSH bootloader is installed"
}

uninstall_bbl () {
  brew remove bbl
}

# Install gcloud console

install_gcloud () {
  echo "Installing Google cloud SDK..."
  brew cask install google-cloud-sdk
  echo "source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'" >> ~/.zshrc
  source ~/.zshrc

  # For configuration run
  # $ gcloud init --console-only
  # and follow the instructions
  echo "Google cloud SDK is installed"
}

uninstall_gcloud () {
  brew cask remove google-cloud-sdk
}

install_tools () {
  install_bosh
  install_terraform
  install_bbl
  install_gcloud
  install_ruby
}

uninstall_tools () {
  uninstall_bbl
  uninstall_bosh
  uninstall_terraform
  uninstall_gcloud
  # uninstall_ruby
}

# Create GCP user and grant rights

provision_user () {
  gcloud iam service-accounts create $BBL_SERVICE_ACCOUNT
  gcloud iam service-accounts keys create \
    --iam-account="$BBL_SERVICE_ACCOUNT@$BBL_PROJECT_ID.iam.gserviceaccount.com" \
    $BBL_SERVICE_ACCOUNT.key.json

  BBL_MEMBER=serviceAccount:$BBL_SERVICE_ACCOUNT@$BBL_PROJECT_ID.iam.gserviceaccount.com

  gcloud projects add-iam-policy-binding $BBL_PROJECT_ID \
    --member=$BBL_MEMBER \
    --role='roles/editor'
}

# Create BOSH Director

create_director () {
  bbl up \
    --gcp-zone europe-west1-b \
    --gcp-region europe-west1 \
    --gcp-service-account-key $BBL_SERVICE_ACCOUNT.key.json \
    --gcp-project-id $BBL_PROJECT_ID \
    --iaas gcp \
    --name bosh
}

# Create load balancer

gen_certs () {
  mkdir ssl
  openssl req \
    -newkey rsa:2048 -nodes -keyout ssl/cf.domain.key \
    -out ssl/cf.domain.crt \
    -sha256 \
    -subj "/C=RU/ST=Moscow/L=Moscow/O=LxSoft/CN=cf.domain.cf" \
    -x509 -days 365
}

create_lb () {
  # You need upgraded GCP account to do this action or you will run out of quota

  bbl create-lbs --type cf \
    --key ssl/cf.domain.cf.key \
    --cert ssl/cf.domain.cf.crt
}

# Upload stemcell

upload_stemcell () {
  STEMCELL_VERSION="3421.11"
  STEMCELL_URL="https://s3.amazonaws.com/bosh-gce-light-stemcells/light-bosh-stemcell-$STEMCELL_VERSION-google-kvm-ubuntu-trusty-go_agent.tgz"
  bosh upload-stemcell $STEMCELL_URL
}

# Deploy Cloud Foundry

deploy_cf () {
  # git clone git@github.com:cloudfoundry/cf-deployment.git
  cd cf-deployment

  echo "system_domain: cf.domain.cf" > cf-deployment-vars.yml
  bosh -n interpolate \
    --vars-store cf-deployment-vars.yml \
    -o operations/scale-to-one-az.yml \
    -o operations/gcp.yml \
    --var-errs cf-deployment.yml

  bosh -d cf deploy  \
    --vars-store cf-deployment-vars.yml \
    -o operations/scale-to-one-az.yml \
    -o operations/gcp.yml \
    cf-deployment.yml
}
# 22s
# install_tools

# 2 s
# asks for user password
# uninstall_tools

# 17 min
# create_director

# Init environment
eval "$(bbl print-env)"

# gen_certs
# 1 min
# create_lb
# 1 min
# upload_stemcell

deploy_cf
