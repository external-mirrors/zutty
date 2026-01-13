#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

IN "source truecolor_inc_01.sh\r"
SNAP truecolor_01 db346f8995e7c5bc8117c5ce09fd8140

IN "source truecolor_inc_02.sh\r"
SNAP truecolor_02 8941c44d73345199cb7b12e7517a7406
