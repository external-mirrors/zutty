#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

CHECK_DEPS setxkbmap

function BASIC_TEST {
    IN "source scrollback_inc.sh\r"

    IN "\S\[Page_Up]\D1"
    SNAP scrollback_01 0f808fe0a89685de4a11cf5631aec583

    IN "\S\[Page_Up]\D1"
    SNAP scrollback_02 bcab9eb18ae717c9077cb1c1b0bbc000

    for x in {0..9} ; do
        IN "\S\[Page_Up]\S\[Page_Up]\S\[Page_Up]\S\[Page_Up]"
    done
    SNAP scrollback_03 df039070ba2ccb002ba3735f8c2f097b

    # Identical to previous snap; already at top of history
    IN "\S\[Page_Up]\D1"
    SNAP scrollback_04 df039070ba2ccb002ba3735f8c2f097b

    # Test jump-to-bottom on input:
    IN "f"
    SNAP scrollback_05 172d7f4fe37a93168f395ddcb8fffb91

    IN "or x in {0..9} ; do echo \$x; done\r"

    IN "\S\[Page_Up]\D1"
    SNAP scrollback_06 d6f753173b658dec22e1a271ca247561

    IN "\S\[Page_Up]\S\[Page_Up]\S\[Page_Up]\D1"
    SNAP scrollback_07 2b46055c15f7d16971335d4c737b1ef0

    IN "\S\[Page_Down]\D1"
    SNAP scrollback_08 a5e10c6bc16195dcfd370e84b6c589a6

    IN "\S\[Page_Down]\S\[Page_Down]\D1"
    SNAP scrollback_09 d6f753173b658dec22e1a271ca247561

    IN "\S\[Page_Down]\S\[Page_Down]\D1"
    SNAP scrollback_10 8364b4e078c4448ef462c0b002bec1ee

    IN "printf \"\\\\e[H\\\\e[3J\"\r" # clear display incl. scrollback
    IN "\S\[Page_Up]\S\[Page_Up]\S\[Page_Up]\S\[Page_Up]\D1"
    SNAP scrollback_11 07403f604b5e89ccaaceba4f177fdcf9
}

BASIC_TEST
