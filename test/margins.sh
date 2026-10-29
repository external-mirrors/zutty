#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

IN "source margins_inc_01.sh\r"
WAIT_FOR_DOT_COMPLETE
SNAP margins_01 a9f2574d276e935f603e2310f69490ad

IN "source margins_inc_02.sh\r"
WAIT_FOR_DOT_COMPLETE
SNAP margins_02 bbfa197866be689f9c1a2fbcf6bedad3
