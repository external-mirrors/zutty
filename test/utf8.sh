#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

function show {
    offset=$1
    IN "printf \"\\\\e[H\\\\e[J\" && tail +${offset} UTF-8-test.txt | head -23 && sleep 2\r"
}

show 63
SNAP utf8_01 1fc60813091569c137cafb67345381de
show 89
SNAP utf8_02 10aab77366bbcb9f6e7b56929229486d
show 112
SNAP utf8_03 e0a1a591ec8ded91602a52cd95ab3aab
show 132
SNAP utf8_04 dab7a6bdee8e9b0ddfc1a5bd903b8d1d
show 152
SNAP utf8_05 621030191772ba2e88a80a9a0093d914
show 171
SNAP utf8_06 d421d3ef8899d36da17bbf5e3db5cfad
show 203
SNAP utf8_07 6893337ebd8ac532fbeed1bbe0048c2e
show 226
SNAP utf8_08 6203bc7fbb7abbb2d33e853ad6db33e5
show 245
SNAP utf8_09 b7c51626ae06825a2d41f5fa975f394c
show 286
SNAP utf8_10 7a6c6d1a4764b55e12251d4b5d04603a
