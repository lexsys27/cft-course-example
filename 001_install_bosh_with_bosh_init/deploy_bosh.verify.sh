#!/bin/bash -e

check 'bosh target' 'Current target is .*' true #> BOSH target should be set.  
