#!/bin/bash -e

check 'bosh --version' 'version*' true  #> No BOSH binary found
check 'bosh --version' '2.0.28*' true  #> Incorrect BOSH version

