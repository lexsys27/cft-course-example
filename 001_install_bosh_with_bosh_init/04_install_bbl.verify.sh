#!/bin/bash -e

check 'bbl --version' 'bbl' true  #> No bbl binary found
check 'bbl --version' '4.0.0' true  #> Incorrect bbl version

