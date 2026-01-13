#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

IN "source nonascii_inc.sh\r"
SNAP nonascii_01 fe6d9c2a60ba632e020379926a1d909b

IN "\r"
SNAP nonascii_02 c3fa274dbaa37fb4e5b200e857d4003b

IN "\r"
SNAP nonascii_03 e320b5421a7b89f92d0e94ff9e7914bc
