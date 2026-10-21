#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

IN "source parser_inc_01.sh\r"
WAIT_FOR_DOT_COMPLETE
SNAP parser_01 4399cb87f6b5c1ca8bc5b00d85ea1c97
WAIT_FOR_DOT_COMPLETE

IN "./parser_errors.sh -at\r"
WAIT_FOR_DOT_COMPLETE
SNAP parser_02 39e173d229fd497abe61d500596d8955
