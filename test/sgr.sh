#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

IN "source sgr_inc_01.sh\r"
SNAP sgr_01 db346f8995e7c5bc8117c5ce09fd8140

IN "source sgr_inc_02.sh\r"
SNAP sgr_02 8941c44d73345199cb7b12e7517a7406

IN "source sgr_inc_03.sh\r"
WAIT_FOR_DOT_COMPLETE
SNAP sgr_03 81b8ddf2076c496c77292a0fef83298a
