#!/bin/sh

# Script to automate image creation for the Google cloud platform

# Create image from ubuntu 16.04 vm

gcloud compute instances create bastion \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --description="for taking images" \
  --labels=owner=lexsys \
  --image-project=ubuntu-os-cloud \
  --machine-type=f1-micro \
  --zone=europe-west1-b \
  --network=default \
  --image-family=ubuntu-1604-lts \
  --no-boot-disk-auto-delete


#  --service-account= \
# Service account will allow this machine to access the API

# list available disk types
# $ gcloud compute disk-types list

# list available machine types
# gcloud compute machine-types list

# You can create images only from root disks that are not attached to an instance

# Do some changes to the instance...

# Delete instance
gcloud compute instances delete bastion \
  --quiet \
  --zone=europe-west1-b

gcloud compute images create platform \
  --source-disk bastion \
  --source-disk-zone europe-west1-b \
  --family=ubuntu-1604-lts

# Now let's create instance from the saved image

gcloud compute instances create bastion \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-standard \
  --description="for testing images" \
  --labels=owner=lexsys \
  --image-project=rnddepartment-156713 \
  --machine-type=f1-micro \
  --zone=europe-west1-b \
  --network=default \
  --image=platform
