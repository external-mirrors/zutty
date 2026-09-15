#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

IN "./parser_errors.sh -at\r"

WAIT_FOR_DOT_COMPLETE

SNAP parser_01 39e173d229fd497abe61d500596d8955
