#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

IN "source tabs_inc_01.sh\r"
SNAP tabs_01 b1e6603a49eb724f1e225fed3cabefb1

IN "source tabs_inc_02.sh\r"
SNAP tabs_02 26fe6077ba6b46ef1ea43430c325ca55
