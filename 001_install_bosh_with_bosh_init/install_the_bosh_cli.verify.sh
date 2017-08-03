#!/bin/bash -e

check 'bosh --version' 'BOSH 1.*' true #> BOSH CLI not installed or version outdated.
