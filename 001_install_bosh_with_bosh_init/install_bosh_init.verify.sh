#!/bin/bash -e

check 'bosh-init -v' '0.0.100' true #> bosh-init not installed or version outdated.
check 'ruby --version' '2.1.*' true #> ruby not installed or version outdated.
