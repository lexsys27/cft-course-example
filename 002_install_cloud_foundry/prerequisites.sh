#!/bin/bash -e

source .profile
check 'bosh target' 'Current target is .*' true #> BOSH target should be set.
