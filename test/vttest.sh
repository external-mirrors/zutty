#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

CHECK_DEPS vttest setxkbmap
VttestReqVsn="VT100 test program, version 2.7 (20210210)"
if [[ $(vttest -V) != $VttestReqVsn ]]
then
    printf "${RED}Error: vttest version mismatch${DFLT}\n"
    echo "   Found version: $(vttest -V)"
    echo "Required version: $VttestReqVsn"
    printf "${YELLOW}Please run test/deps/install_vttest.sh${DFLT}\n"
    exit 1
fi

LangReq="en_US.UTF-8"
if [[ $LANG != $LangReq ]]
then
    echo "Error: need LANG set to $LangReq, found $LANG"
    exit 1
fi

function VT_1 {
    IN "1\r"
    SNAP vt_01_01 b6ab7b1334101ce9239e5fb799aea39d
    IN "\r"
    SNAP vt_01_02 e077a3360e9f070e0d07d8646c7d6fdb
    IN "\r"
    SNAP vt_01_03 36491b5ca5cfad2f54398878e0869576
    IN "\r"
    SNAP vt_01_04 36491b5ca5cfad2f54398878e0869576
    IN "\r"
    SNAP vt_01_05 4270af70e1d90e115db8f35704f249e4
    IN "\r"
    SNAP vt_01_06 f0e67171f02e29ef7da347af413f7754
    IN "\r"
}

function VT_2 {
    IN "2\r"
    SNAP vt_02_01 730609966a4bb3bbfaab90cce2209a12
    IN "\r"
    SNAP vt_02_02 9594590fafa59556adb2401630f0cb68
    IN "\r"
    SNAP vt_02_03 28e65711c49fa91387ec897d9e2d8d9e
    IN "\r"
    SNAP vt_02_04 8eb669fa56e56595071587d24777b513
    IN "\r"
    SNAP vt_02_05 c068e2e171b099c7031bd9768f943c83
    IN "\r"
    SNAP vt_02_06 25a8d5fb4f10c367450f62a26be354fb
    IN "\r"
    SNAP vt_02_07 824137eae9261af6d4f429fd8077b50d
    IN "\r"
    SNAP vt_02_08 738082b3df45cf7d7554aa9f05125adb
    IN "\r"
    SNAP vt_02_09 2f28eca77b1c5ab0916d8f723feacdfe
    IN "\r"
    SNAP vt_02_10 43aa9ae425859d3417eeb314fe704329
    IN "\r"
    SNAP vt_02_11 44ad669ad2757875b2b2d7d3d12f296e
    IN "\r"
    SNAP vt_02_12 5d8b521549eb06824fd2f6d0ddea4f31
    IN "\r"
    SNAP vt_02_13 48fb10b0dd4742dbfbd7199893ebc526
    IN "\r"
    SNAP vt_02_14 17f2fb94bfb1c69be1aa9d88dec11a23
    IN "\r"
    SNAP vt_02_15 80c1fcc7053689494902b621a55338cf
    IN "\r"
}

function VT_3_VT220 {
    IN "3\r"
    IN "8\r" # Test VT100 Character Sets
    SNAP vt_03_08 89efd5ead4740ee6b9e9dcb04aa93cb5
    IN "\r"
    IN "9\r" # Test Shift In/Shift Out (SI/SO)
    SNAP vt_03_09 387647270a559b7a4cc892136b7fcd7e
    IN "\r"
    IN "7\r" # Specify G3
    IN "2\r" # -> DEC Special Graphics and Line Drawing
    IN "10\r" # Test VT220 Locking Shifts
    SNAP vt_03_10_01 0121cc2aa8199d8f90c5d94220ec0362
    IN "\r"
    IN "11\r" # Test VT220 Single Shifts
    SNAP vt_03_11_01 9ee2a844efd0a82215d5555f30f1d4a1
    IN "\r"
    SNAP vt_03_11_02 b61883fce9e5401d87548c1a73b40040
    IN "\r"
    IN "6\r" # Specify G2
    IN "4\r" # -> DEC Supplemental Graphic
    IN "7\r" # Specify G3
    IN "5\r" # -> DEC Technical
    IN "10\r" # Test VT220 Locking Shifts
    SNAP vt_03_10_02 830ebf5b23eb1b3b9b2ae607247727ed
    IN "\r"
    IN "11\r" # Test VT220 Single Shifts
    SNAP vt_03_11_03 f51e00fe682b16aa85eba592b4939b39
    IN "\r"
    SNAP vt_03_11_04 d475baf4aa48abaf9cbb35fb43617a9e
    IN "\r"
    IN "0\r"
}

function VT_3_VT100 {
    IN "3\r"
    SNAP vt_03_01
    IN "\r"
}

function VT_3 {
    if [ ! -z ${SUPPORTS_VT220} ] ; then
        VT_3_VT220
    else
        VT_3_VT100
    fi
}

function VT_5 {
    IN "5\r"
    IN "3\r" # Keyboard Layout
    if [ -z ${SUPPORTS_VT220} ] ; then
        IN "0\r" # Standard American ANSI layout
    fi
    IN " \t\{BackSpace}"
    IN "\`1234567890-=[];',./\\\\"
    IN "~!@#$%^&*()_+{}:\"<>?|"
    IN "abcdefghijklmnopqrstuvwxyz"
    IN "ABCDEFGHIJKLMNOPQRSTUVWXYZ\r"
    SNAP vt_05_03 7a8c7031ea14ed1c4488cdeec95ee293
    IN "\r"
    IN "4\r" # Cursor Keys
    IN "\{Up}\D1\{Down}\D1\{Right}\D1\{Left}\D1"
    SNAP vt_05_04_01 7a428c750c2e6a1aab426ece1d2cf6f5
    IN "\t\D1"
    IN "\{Up}\D1\{Down}\D1\{Right}\D1\{Left}\D1"
    SNAP vt_05_04_02 2a6aa7e098405b3765403e1ae459ae88
    IN "\t\D1"
    IN "\{Up}\D1\{Down}\D1\{Right}\D1\{Left}\D1"
    SNAP vt_05_04_03 6733689ffd204bbe4d015919e5720a59
    IN "\t\D1"
    IN "\r"

    IN "5\r" # Numeric Keypad
    # VT100 Numeric mode - send "NumLock on" keysyms
    IN "\{KP_F1}\D1\{KP_F2}\D1\{KP_F3}\D1\{KP_F4}"
    IN "\{KP_0}\D1\{KP_1}\D1\{KP_2}\D1\{KP_3}\D1\{KP_4}"
    IN "\{KP_5}\D1\{KP_6}\D1\{KP_7}\D1\{KP_8}\D1\{KP_9}"
    IN "\{KP_Subtract}\D1\{KP_Separator}\D1\{KP_Decimal}\D1\{KP_Enter}"
    SNAP vt_05_05_01 a441733d41c6b9c2a3cdd38b2098cd5e
    IN "\t\D1"
    # VT100 Application mode - send "NumLock off" keysyms
    IN "\{KP_F1}\D1\{KP_F2}\D1\{KP_F3}\D1\{KP_F4}"
    IN "\{KP_Insert}\D1\{KP_End}\D1\{KP_Down}\D1\{KP_Page_Down}\D1\{KP_Left}"
    IN "\{KP_Begin}\D1\{KP_Right}\D1\{KP_Home}\D1\{KP_Up}\D1\{KP_Page_Up}"
    IN "\{KP_Subtract}\D1\{KP_Separator}\D1\{KP_Delete}\D1\{KP_Enter}"
    SNAP vt_05_05_02 640e3c8460b20a347fad32dde81978f1
    IN "\t\D1"
    # VT52 Numeric mode
    IN "\{KP_F1}\D1\{KP_F2}\D1\{KP_F3}\D1\{KP_F4}"
    IN "\{KP_0}\D1\{KP_1}\D1\{KP_2}\D1\{KP_3}\D1\{KP_4}"
    IN "\{KP_5}\D1\{KP_6}\D1\{KP_7}\D1\{KP_8}\D1\{KP_9}"
    IN "\{KP_Subtract}\D1\{KP_Separator}\D1\{KP_Decimal}\D1\{KP_Enter}"
    SNAP vt_05_05_03 ee01cfe71ebd5a2ba564ba8804e30f35
    IN "\t\D1"
    # VT52 Application mode
    IN "\{KP_F1}\D1\{KP_F2}\D1\{KP_F3}\D1\{KP_F4}"
    IN "\{KP_Insert}\D1\{KP_End}\D1\{KP_Down}\D1\{KP_Page_Down}\D1\{KP_Left}"
    IN "\{KP_Begin}\D1\{KP_Right}\D1\{KP_Home}\D1\{KP_Up}\D1\{KP_Page_Up}"
    IN "\{KP_Subtract}\D1\{KP_Separator}\D1\{KP_Decimal}\D1\{KP_Enter}"
    SNAP vt_05_05_04 bf7f92d41c51ddbba808dc32e4aa1b66
    IN "\t\D1"
    IN "\r"

    if [ ! -z ${SUPPORTS_VT220} ] ; then
        IN "6\r" # Editing Keypad
        IN "\{Insert}\D1\{Delete}\D1\{Page_Up}\D1\{Page_Down}"
        SNAP vt_05_06_01 e0d7ba34ab8a0e9a9cf194726ee98d2a
        IN "\t\D1"
        IN "\{Insert}\D1\{Delete}\D1\{Page_Up}\D1\{Page_Down}"
        SNAP vt_05_06_02 258cd24e3fd2a8df52d88812e49f32ec
        IN "\t\D1"
        IN "\{Insert}\D1\{Delete}\D1\{Page_Up}\D1\{Page_Down}"
        SNAP vt_05_06_03 769965a64f7a8b4dba5071bb864cae81
        IN "\r"

        IN "7\r" # Function Keys
        IN "\{F1}\D1\{F2}\D1\{F3}\D1\{F4}\D1\{F5}\D1\{F6}\D1\{F7}\D1\{F8}"
        IN "\{F9}\D1\{F10}\D1\{F11}\D1\{F12}\D1\{F13}\D1\{F14}"
        SNAP vt_05_07_01 4fec2c2e22e6ea7ba204e7df52088b39
        IN "\t\D1"
        IN "\{F1}\D1\{F2}\D1\{F3}\D1\{F4}\D1\{F5}\D1\{F6}\D1\{F7}\D1\{F8}"
        IN "\{F9}\D1\{F10}\D1\{F11}\D1\{F12}\D1\{F13}\D1\{F14}"
        SNAP vt_05_07_02 713ca101be8a503b13dd6a44e673858c
        IN "\t\D1"
        IN "\r"
    fi

    IN "9\r" # Control Keys
    IN "\C@\C@\Ca\Ca\Cb\Cb\Cc\Cc\Cd\Cd\Ce\Ce\Cf\Cf\Cg\Cg"
    IN "\Ch\Ch\Ci\Ci\Cj\Cj\Ck\Ck\Cl\Cl\Cm\Cm\Cn\Cn\Co\Co"
    IN "\Cp\Cp\Cq\Cq\Cr\Cr\Cs\Cs\Ct\Ct\Cu\Cu\Cv\Cv\Cw\Cw"
    IN "\Cx\Cx\Cy\Cy\Cz\Cz\C[\C[\C_\C_\C]\C]\C^\C^\C\\\\\C\\\\"
    IN "\b"
    SNAP vt_05_09 5e4dc23fd50563d690de0759fc4a690e
    IN "\r"
    IN "0\r"
 }

function VT_6 {
    IN "6\r"
    IN "1\r" # <ENQ> (AnswerBack Message)
    if [ ! -z ${MISSING_ANSWERBACK} ] ; then
        IN "\r"
    fi
    SNAP vt_06_01 eaa22977fa5a2294fe807a9e66d343b4
    IN "\r"
    IN "2\r" # Set/Reset Mode - LineFeed / Newline
    IN "\r\D5\r"
    SNAP vt_06_02 588e2f3725134dcc32d89e836b85bb4e
    IN "\r"
    IN "3\r\D5" # Device Status Report (DSR)
    if [ ! -z ${MISSING_DSR} ] ; then
        IN "\r"
    fi
    SNAP vt_06_03 51df0b6c4562a071b22eaa8fdf3e2e9d
    IN "\r"
    IN "4\r" # Primary DA
    SNAP vt_06_04 c008f0afadb164be25a9590c5deca111
    IN "\r"
    IN "5\r" # Secondary DA
    if [ ! -z ${MISSING_SECONDARY_DA} ] ; then
        IN "\r"
    fi
    SNAP vt_06_05 1a480b1a8a6b5c4595e8da4798f37668
    IN "\r"
    IN "0\r"
}

function VT_7 {
    if [ -z ${SUPPORTS_VT52} ] ; then
        return
    fi

    IN "7\r"
    SNAP vt_07_01 b5f31cfb13ed69de36ffa718099bafb5
    IN "\r"
    SNAP vt_07_02 20760196dd2ad0652ee4a722aba24322
    IN "\r"
    SNAP vt_07_03 530a38b9aaea2afdfac900a5db94d14c
    IN "\r"
    SNAP vt_07_04 d9f0e8ed60e2fa9f9b2e79aa6dc637a0
    IN "\r"
}

function VT_8 {
    IN "8\r"
    SNAP vt_08_01 45b08b59d610b5b77782639e1a2885b6
    IN "\r"
    SNAP vt_08_02 d14f838379cb62451b7d720dcf972847
    IN "\r"
    SNAP vt_08_03 6b4630370048e8a887be37675d161e4f
    IN "\r"
    SNAP vt_08_04 845cc43e74e92244fec5b0b0e29b0bab
    IN "\r"
    SNAP vt_08_05 9d36aa788ba732e8ee5479691682dd42
    IN "\r"
    SNAP vt_08_06 668073f138f033e923cd5608000fbd25
    IN "\r"
    SNAP vt_08_07 489fb78fd33be51673c58a7fa6503b3c
    IN "\r"
    SNAP vt_08_08 e60332655367b22480364347010ca903
    IN "\r"
    SNAP vt_08_09 84a6ae2a0fa26b774a9e7c35c7af5239
    IN "\r"
    SNAP vt_08_10 544111cdca12ffb843d7f070b6f9c740
    IN "\r"
    SNAP vt_08_11 acd64a2ea6b373f64f0267e0fc1c2714
    IN "\r"
    SNAP vt_08_12 a73c4855cc17770ae1180a9b0e27e81a
    IN "\r"
    SNAP vt_08_13 f2f7f5ba6549bccabd0582574e4aa28b
    IN "\r"
    SNAP vt_08_14 489fb78fd33be51673c58a7fa6503b3c
    IN "\r"
}

function VT_9 {
    IN "9\r"
    IN "1\r"
    IN "\r"
    IN "\r\D1\r\D1\r\D1\r\D1\r\D1\r\D1\r\D1\r\D1\r\D1\r"
    SNAP vt_09_01 55b566e5379d36b32ba63dceef96703d
    IN "\r"

    IN "2\r"
    IN "\r"
    SNAP vt_09_02 b97755a34e81bee16d79bb597d0dbfca
    IN "\r"

    IN "3\r"
    SNAP vt_09_03 3266b68558b673b3bf29a88b45dcba2b
    IN "\r"

    IN "4\r"
    SNAP vt_09_04 834a8ea3c328e973ca04652ee21ae915
    IN "0\r"
    IN "\r"

    IN "5\r"
    SNAP vt_09_05 7323c57eafb5d379de3a38698e1093c5
    IN "\r"

    IN "6\r"
    SNAP vt_09_06_01 9144a6ac19fc3e0299a92cd2f5c475f9
    IN "\r"
    SNAP vt_09_06_02 2d96c2082671372441137f80794809ac
    IN "\r"

    IN "7\r"
    SNAP vt_09_07 d140240194a8e82a892a9b409d7bbf30
    IN "\r"

    IN "8\r"
    SNAP vt_09_08_01 a702907ba36e8ae59b719f02c2753c53
    IN "\r"
    SNAP vt_09_08_02 c1bcc9827ef68d5c79df6ee94e77092e
    IN "\r"
    SNAP vt_09_08_03 8ae61ad9c3f4eb5351030a7f109dbc4d
    IN "\r"
    SNAP vt_09_08_04 fabcf5dea4c4160b1308af77b73e2055
    IN "\r"
    SNAP vt_09_08_05 68480e551460200ea7e8ff47766660d1
    IN "\r"
    SNAP vt_09_08_06 9006b1dc5e2dbc80ec394f4843fe0a7f
    IN "\r"

    IN "9\r"
    SNAP vt_09_09_01 b76bc190be124f0456cffd098fc9f1a1
    IN "\r"
    SNAP vt_09_09_02 b76bc190be124f0456cffd098fc9f1a1
    IN "\r"

    IN "0\r"
}

function VT_10 {
    IN "10\r"
    IN "1\r"
    IN "\r"
    sleep 5
    SNAP vt_10_01 39ef89fe2820ecc9d270e8badf7ac9c4
    IN "\r"

    IN "3\r"
    IN "\r"
    SNAP vt_10_03 93f740cbf0af6d2455b6862ca5caeb6c
    IN "\r"

    IN "0\r"
}

function VT_11 {
    IN "11\r"

    IN "1\r" # VT220 Tests
    IN "2\r" # VT220 Screen-Display Tests
    IN "1\r" # Test Send/Receive Mode
    IN "Subidubidoo\D1Subidubidoo\D1"
    SNAP vt_11_01_02_01 c8128c0332c2a1f293bc84afcfe7ac58
    IN "\r"
    IN "2\r" # Test Visible/Invisible Cursor
    SNAP vt_11_01_02_02_01 f6d40a850a11d28d79732344e130c84f
    IN "\r"
    SNAP vt_11_01_02_02_02 2a18ff8ede14e5bf53ccf7e878d55889
    IN "\r"
    IN "3\r" # Test Erase Char (ECH)
    SNAP vt_11_01_02_03 335193a5717e57300a3fb7585eab826e
    IN "\r"
    IN "0\r"
    IN "0\r"

    IN "2\r" # VT320 Tests
    IN "2\r" # Test cursor-movement
    IN "1\r" # Test Pan Down (SU)
    SNAP vt_11_02_02_01 269e4108b55a05ca1fa0c6983b2fc15f
    IN "\r"
    IN "2\r" # Test Pan Up (SD)
    SNAP vt_11_02_02_02 13490d53ba92e3ffb28a46cb62cb7bb2
    IN "\r"
    IN "0\r"
    IN "0\r"

    IN "3\r" # VT420 Tests
    IN "2\r" # Test cursor-movement
    IN "6\r" # Color test-regions
    IN "7\r" # Test Back Index (BI)
    SNAP vt_11_03_02_07_01 f626a1dc7f1051565862fa5f6593ada0
    IN "\r"
    IN "8\r" # Test Forward Index (FI)
    SNAP vt_11_03_02_08_01 fb1d091eec6d6dd6ac1bd64c6eff4239
    IN "\r"
    IN "9\r" # Test cursor movement within margins
    SNAP vt_11_03_02_09_01 8f14c102767e372bc3b202981f3d6c50
    IN "\r"
    IN "10\r" # Test other movement within margins
    SNAP vt_11_03_02_10_01 162577727ba7835b19198fd1762efe28
    IN "\r"
    IN "4\r" # Top/Bottom margins are set to top half of screen
    IN "7\r" # Test Back Index (BI)
    SNAP vt_11_03_02_07_02 49c535f04bf99d3b0eceb49f0d4a74a7
    IN "\r"
    IN "8\r" # Test Forward Index (FI)
    SNAP vt_11_03_02_08_02 6722c660a3c4bf5eabbf33d6c4cb44d0
    IN "\r"
    IN "9\r" # Test cursor movement within margins
    SNAP vt_11_03_02_09_02 8453ed19f738d251bebb0c7988ac26d1
    IN "\r"
    IN "10\r" # Test other movement within margins
    SNAP vt_11_03_02_10_02 1b4b0a0cb140fe4f2418689080283d6c
    IN "\r"
    IN "4\r" # Top/Bottom margins are set to bottom half of screen
    IN "7\r" # Test Back Index (BI)
    SNAP vt_11_03_02_07_03 6a8e28a38ab3edbc6d3d227d80662a42
    IN "\r"
    IN "8\r" # Test Forward Index (FI)
    SNAP vt_11_03_02_08_03 826e260e0d1fcc75fe2732e7d60dab8b
    IN "\r"
    IN "9\r" # Test cursor movement within margins
    SNAP vt_11_03_02_09_03 503d48c9fda45e88d28a35d4876dc96d
    IN "\r"
    IN "10\r" # Test other movement within margins
    SNAP vt_11_03_02_10_03 305793ffb6eb60d300ddfc891455aa04
    IN "\r"
    IN "4\r" # Top/Bottom margins are set to middle half of screen
    IN "7\r" # Test Back Index (BI)
    SNAP vt_11_03_02_07_04 478c3a583f0f1e9070d7396c17747273
    IN "\r"
    IN "8\r" # Test Forward Index (FI)
    SNAP vt_11_03_02_08_04 a63af988eac3f133dcbe67793d5feaf4
    IN "\r"
    IN "9\r" # Test cursor movement within margins
    SNAP vt_11_03_02_09_04 5274886dd9357cc0a9b54ec64f10bdd7
    IN "\r"
    IN "10\r" # Test other movement within margins
    SNAP vt_11_03_02_10_04 bb528a3d3d68e2a59c335c63cc79af35
    IN "\r"
    IN "4\r" # Top/Bottom margins are reset
    IN "3\r" # Enable DECLRMM (left/right mode)
    IN "5\r" # Left/Right margins are set to left half of screen
    IN "7\r" # Test Back Index (BI)
    SNAP vt_11_03_02_07_05 0ec198a440c6bc92a1865d74cc008b26
    IN "\r"
    IN "8\r" # Test Forward Index (FI)
    SNAP vt_11_03_02_08_05 b7ef3a10bdc7e94d8a936df8b2b54b84
    IN "\r"
    IN "9\r" # Test cursor movement within margins
    SNAP vt_11_03_02_09_05 5cbcd135b8c82d2b39547bf747c87474
    IN "\r"
    IN "10\r" # Test other movement within margins
    SNAP vt_11_03_02_10_05 7a58a134d62de4ee2667a519cb26acbb
    IN "\r"
    IN "5\r" # Left/Right margins are set to right half of screen
    IN "7\r" # Test Back Index (BI)
    SNAP vt_11_03_02_07_06 5557b8e0921f04d6c9448162a0707169
    IN "\r"
    IN "8\r" # Test Forward Index (FI)
    SNAP vt_11_03_02_08_06 8ef32b1aaf0eddde2f68b0a7dddbf9b8
    IN "\r"
    IN "9\r" # Test cursor movement within margins
    SNAP vt_11_03_02_09_06 eb702420724e84a545c1fa49166b1c4f
    IN "\r"
    IN "10\r" # Test other movement within margins
    SNAP vt_11_03_02_10_06 a6191ce44e7142f2c6524af3c43b5777
    IN "\r"
    IN "5\r" # Left/Right margins are set to middle half of screen
    IN "7\r" # Test Back Index (BI)
    SNAP vt_11_03_02_07_07 b16962defba836e1990921aaabebc6a8
    IN "\r"
    IN "8\r" # Test Forward Index (FI)
    SNAP vt_11_03_02_08_07 fd5dc63c83cb2e494808894d179675a9
    IN "\r"
    IN "9\r" # Test cursor movement within margins
    SNAP vt_11_03_02_09_07 8d6e96f71f3f913f25955ba24825b6f4
    IN "\r"
    IN "10\r" # Test other movement within margins
    SNAP vt_11_03_02_10_07 50f9400f50b04647d86d836a07be04ea
    IN "\r"
    IN "0\r"

    IN "3\r" # VT420 Editing Sequences
    IN "5\r" # Color test-regions
    IN "9\r" # Test insert/delete column (DECIC, DECDC)
    SNAP vt_11_03_03_09_01a 2dcaad415d68f92f190612184a90feb1
    IN "\r"
    SNAP vt_11_03_03_09_01b ef19386e7743e3e16f7c54fa897b173e
    IN "\r"
    IN "10\r\r" # Test vertical scrolling (IND, RI)
    SNAP vt_11_03_03_10_01a a4b2b4385a8cb011937de47961edaf24
    IN "\r\r"
    SNAP vt_11_03_03_10_01b 3a1546740d015b6477c5c325fc71df61
    IN "\r"
    IN "11\r\r" # Test insert/delete line (IL, DL)
    SNAP vt_11_03_03_11_01a 3a1546740d015b6477c5c325fc71df61
    IN "\r\r"
    SNAP vt_11_03_03_11_01b a4b2b4385a8cb011937de47961edaf24
    IN "\r"
    IN "12\r" # Test insert/delete char (ICH, DCH)
    SNAP vt_11_03_03_12_01a 8dcfc3a694c9fb8d0213094dc161f03e
    IN "\r"
    SNAP vt_11_03_03_12_01b cbfa5b65ca90a4ae7325ea5c71183e87
    IN "\r"
    IN "13\r" # Test ASCII formatting (BS, CR, TAB)
    SNAP vt_11_03_03_13_01 f362c77bf83420b2c4b6ddcc171e1b29
    IN "\r"
    IN "3\r" # Top/Bottom margins are set to top half of screen
    IN "9\r" # Test insert/delete column (DECIC, DECDC)
    SNAP vt_11_03_03_09_02a df916a0e28bc635b5cf1eda4faa6d51f
    IN "\r"
    SNAP vt_11_03_03_09_02b 13c3fee614b4f574cce38885f4514933
    IN "\r"
    IN "10\r\r" # Test vertical scrolling (IND, RI)
    SNAP vt_11_03_03_10_02a acdf7df2bb0fa149883f7cf95851fbc5
    IN "\r\r"
    SNAP vt_11_03_03_10_02b cd86415840659a6c9ca64152ffeed8bf
    IN "\r"
    IN "11\r\r" # Test insert/delete line (IL, DL)
    SNAP vt_11_03_03_11_02a 62a92779ba871ea6ab430436d2717f5f
    IN "\r\r"
    SNAP vt_11_03_03_11_02b c5e32d4d9e418750552f139c6eb92e46
    IN "\r"
    IN "12\r" # Test insert/delete char (ICH, DCH)
    SNAP vt_11_03_03_12_02a 7f7c8e7ce0cb64108a26d2815e68ef85
    IN "\r"
    SNAP vt_11_03_03_12_02b d94434939a216d02efef1380eaaa6371
    IN "\r"
    IN "13\r" # Test ASCII formatting (BS, CR, TAB)
    SNAP vt_11_03_03_13_02 990496e88d143169721df011a286f1cf
    IN "\r"
    IN "3\r" # Top/Bottom margins are set to bottom half of screen
    IN "9\r" # Test insert/delete column (DECIC, DECDC)
    SNAP vt_11_03_03_09_03a b05644a9dc07e0d1944e1fa9e6e583c1
    IN "\r"
    SNAP vt_11_03_03_09_03b 313fb3405dfd96e6b7e1c6ce8c2f5310
    IN "\r"
    IN "10\r\r" # Test vertical scrolling (IND, RI)
    SNAP vt_11_03_03_10_03a 4e1eaaeaa1dcd248af0b0756e981150c
    IN "\r\r"
    SNAP vt_11_03_03_10_03b 34c4954aa36b605a8a73a3d42ef50b44
    IN "\r"
    IN "11\r\r" # Test insert/delete line (IL, DL)
    SNAP vt_11_03_03_11_03a 858974f602c5735742c432bd2ad1174a
    IN "\r\r"
    SNAP vt_11_03_03_11_03b 0778ba8017656704b9bc844629545bc2
    IN "\r"
    IN "12\r" # Test insert/delete char (ICH, DCH)
    SNAP vt_11_03_03_12_03a f1f265fd7c5eb52edface642cf54a0d4
    IN "\r"
    SNAP vt_11_03_03_12_03b e89ab76d295da46bb62dbbf9f1df99e3
    IN "\r"
    IN "13\r" # Test ASCII formatting (BS, CR, TAB)
    SNAP vt_11_03_03_13_03 ceebea491bed6c33fbbbe2590776faca
    IN "\r"
    IN "3\r" # Top/Bottom margins are set to middle half of screen
    IN "9\r" # Test insert/delete column (DECIC, DECDC)
    SNAP vt_11_03_03_09_04a 9218028f8a7b9fc935d67a0f53883d1d
    IN "\r"
    SNAP vt_11_03_03_09_04b b4ed47ccec24108dde2406050255d502
    IN "\r"
    IN "10\r\r" # Test vertical scrolling (IND, RI)
    SNAP vt_11_03_03_10_04a e718d4ead9732e6f1b63487c07e58eff
    IN "\r\r"
    SNAP vt_11_03_03_10_04b 258a54f08fc0d9793d31f4a51cda6d64
    IN "\r"
    IN "11\r\r" # Test insert/delete line (IL, DL)
    SNAP vt_11_03_03_11_04a 734d1af1b48a93b680c7ef1aeb9ea8af
    IN "\r\r"
    SNAP vt_11_03_03_11_04b 5c34d5ee0a8827be38469b412f8a000d
    IN "\r"
    IN "12\r" # Test insert/delete char (ICH, DCH)
    SNAP vt_11_03_03_12_04a cd37595de10e5c71b48e88753f5204d8
    IN "\r"
    SNAP vt_11_03_03_12_04b 5aa14051bd1d64851e96793ee8b16f1a
    IN "\r"
    IN "13\r" # Test ASCII formatting (BS, CR, TAB)
    SNAP vt_11_03_03_13_04 e14b3507eeea02f9db1418f2f39fae56
    IN "\r"
    IN "3\r" # Top/Bottom margins are reset
    IN "2\r" # Enable DECLRMM (left/right mode)
    IN "4\r" # Left/Right margins are set to left half of screen
    IN "9\r" # Test insert/delete column (DECIC, DECDC)
    SNAP vt_11_03_03_09_05a 3ec338ee1fe30ad2b0b2d49f6addf3f5
    IN "\r"
    SNAP vt_11_03_03_09_05b 09273d7cbd8ca9c0f95d0e7f33099916
    IN "\r"
    IN "10\r\r" # Test vertical scrolling (IND, RI)
    SNAP vt_11_03_03_10_05a 170f66e6643a6f693a26250e462801ca
    IN "\r\r"
    SNAP vt_11_03_03_10_05b 766824334e09f04a69d7ea84a75744c4
    IN "\r"
    IN "11\r\r" # Test insert/delete line (IL, DL)
    SNAP vt_11_03_03_11_05a 69c7a4c13b1f82c5219a441a310f0428
    IN "\r\r"
    SNAP vt_11_03_03_11_05b acd202c5149ed46b85ace7542d69dc09
    IN "\r"
    IN "12\r" # Test insert/delete char (ICH, DCH)
    SNAP vt_11_03_03_12_05a e343bab8316813795d6df29fcefd3b41
    IN "\r"
    SNAP vt_11_03_03_12_05b 25cc7aff44d273a7fbe1257653652ced
    IN "\r"
    IN "13\r" # Test ASCII formatting (BS, CR, TAB)
    SNAP vt_11_03_03_13_05 7185c8a69506398254ede93f91a074da
    IN "\r"
    IN "4\r" # Left/Right margins are set to right half of screen
    IN "9\r" # Test insert/delete column (DECIC, DECDC)
    SNAP vt_11_03_03_09_06a 338ff44d45b92ed16b3622bd189bf579
    IN "\r"
    SNAP vt_11_03_03_09_06b 60ccdfd3cd5c34a92b476a1c2aeb8514
    IN "\r"
    IN "10\r\r" # Test vertical scrolling (IND, RI)
    SNAP vt_11_03_03_10_06a e83a0a1b39f032091f16aac81740589a
    IN "\r\r"
    SNAP vt_11_03_03_10_06b a8294809bb1c0c6c964e3c768d6d3d17
    IN "\r"
    IN "11\r\r" # Test insert/delete line (IL, DL)
    SNAP vt_11_03_03_11_06a 0011fa4a27f8c28404781f702c87ad74
    IN "\r\r"
    SNAP vt_11_03_03_11_06b 8509b3a1bc75ca872f71a15ac3fe5add
    IN "\r"
    IN "12\r" # Test insert/delete char (ICH, DCH)
    SNAP vt_11_03_03_12_06a 74212a37f91e3e2b97bb80fa36003b13
    IN "\r"
    SNAP vt_11_03_03_12_06b 51da30e7355aefa31f8ba9f3654e83eb
    IN "\r"
    IN "13\r" # Test ASCII formatting (BS, CR, TAB)
    SNAP vt_11_03_03_13_06 404d64579f54cbddfd1576a4c8e13f81
    IN "\r"
    IN "4\r" # Left/Right margins are set to middle half of screen
    IN "9\r" # Test insert/delete column (DECIC, DECDC)
    SNAP vt_11_03_03_09_07a 973b275b0927cf0876a833b7c48532aa
    IN "\r"
    SNAP vt_11_03_03_09_07b 132592e93738ca66ba824b06a9d67c80
    IN "\r"
    IN "10\r\r" # Test vertical scrolling (IND, RI)
    SNAP vt_11_03_03_10_07a 76ac7587b1d297c0feb5ceedc16a425b
    IN "\r\r"
    SNAP vt_11_03_03_10_07b 8263cfe57bd1f7e145c955ea937511dc
    IN "\r"
    IN "11\r\r" # Test insert/delete line (IL, DL)
    SNAP vt_11_03_03_11_07a 8e9530de7af24ae70e3d7f2d501a5291
    IN "\r\r"
    SNAP vt_11_03_03_11_07b 5e0bcbd6eaca4a035a0dc8d0b9d60fc4
    IN "\r"
    IN "12\r" # Test insert/delete char (ICH, DCH)
    SNAP vt_11_03_03_12_07a 1f5db915bfa278c441d74c44900c6efb
    IN "\r"
    SNAP vt_11_03_03_12_07b c9e6d7f3c7463b14dab2b77b36713483
    IN "\r"
    IN "13\r" # Test ASCII formatting (BS, CR, TAB)
    SNAP vt_11_03_03_13_07 bbc1e2a1f01d3a3178ea717133319b49
    IN "\r"
    IN "0\r"

    IN "4\r" # VT420 Keyboard-Control Tests
    IN "1\r" # Test Backarrow Key (DECBKM)
    IN "\b\D3\b"
    SNAP vt_11_03_04_01 32f95b6b00a93b59cba0a176836c3fff
    IN "\r"
    IN "0\r"
    IN "0\r"

    IN "4\r" # VT520 Tests
    IN "2\r" # VT520 cursor-movement
    IN "6\r" # Color test-regions
    IN "7\r" # Test Character-Position-Absolute (HPA)
    SNAP vt_11_04_02_07_01 4e063be1653a917cbbe609c7b74d787f
    IN "\r"
    IN "8\r" # Test Cursor-Back-Tab (CBT)
    SNAP vt_11_04_02_08_01 4203192dd994cf9a2e37290258bf50fe
    IN "\r"
    IN "9\r" # Test Cursor-Character-Absolute (CHA)
    SNAP vt_11_04_02_09_01 e189672e0800840739647d751edc48f0
    IN "\r"
    IN "10\r" # Test Cursor-Horizontal-Index (CHT)
    SNAP vt_11_04_02_10_01 c5f88920f62ebcceb96f8f2b097cf2c0
    IN "\r"
    IN "11\r" # Test Horizontal-Position-Relative (HPR)
    SNAP vt_11_04_02_11_01 1e974ef8f900e24806d64d8618cdb570
    IN "\r"
    IN "12\r" # Test Line-Position-Absolute (VPA)
    SNAP vt_11_04_02_12_01 5781eab34a00b63547bde02bdac6bf9b
    IN "\r"
    IN "13\r" # Test Next-Line (CNL)
    SNAP vt_11_04_02_13_01 08f51b099bb57525dcebdb9303258461
    IN "\r"
    IN "14\r" # Test Previous-Line (CPL)
    SNAP vt_11_04_02_14_01 06ff9f865852070ddc28c89b11d581c9
    IN "\r"
    IN "15\r" # Test Vertical-Position-Relative (VPR)
    SNAP vt_11_04_02_15_01 cb2dd878beb0734cf53540f724eb9f85
    IN "\r"
    IN "4\r" # Top/Bottom margins are set to top half of screen
    IN "7\r" # Test Character-Position-Absolute (HPA)
    SNAP vt_11_04_02_07_02 2f373da774b6e8fee332b5d7f475a69a
    IN "\r"
    IN "8\r" # Test Cursor-Back-Tab (CBT)
    SNAP vt_11_04_02_08_02 bbcf050c91a755e47ace31de05767d61
    IN "\r"
    IN "9\r" # Test Cursor-Character-Absolute (CHA)
    SNAP vt_11_04_02_09_02 bd98e5a8cd81fb2a8921111f293b4250
    IN "\r"
    IN "10\r" # Test Cursor-Horizontal-Index (CHT)
    SNAP vt_11_04_02_10_02 70526a92aa03ffdc097d6c792ed27fa8
    IN "\r"
    IN "11\r" # Test Horizontal-Position-Relative (HPR)
    SNAP vt_11_04_02_11_02 46df91e4a63048bf5d5c8917b9b78eb7
    IN "\r"
    IN "12\r" # Test Line-Position-Absolute (VPA)
    SNAP vt_11_04_02_12_02 402c998798c796a8ca1992996a481563
    IN "\r"
    IN "13\r" # Test Next-Line (CNL)
    SNAP vt_11_04_02_13_02 14a828bd39bfc207671ba12201d76198
    IN "\r"
    IN "14\r" # Test Previous-Line (CPL)
    SNAP vt_11_04_02_14_02 459cfe6886a0807b1b503970d2011595
    IN "\r"
    IN "15\r" # Test Vertical-Position-Relative (VPR)
    SNAP vt_11_04_02_15_02 3a723cc0c9d426026b81343e5965f396
    IN "\r"
    IN "4\r" # Top/Bottom margins are set to bottom half of screen
    IN "7\r" # Test Character-Position-Absolute (HPA)
    SNAP vt_11_04_02_07_03 144895ccd5505a6ffb875e26ec726083
    IN "\r"
    IN "8\r" # Test Cursor-Back-Tab (CBT)
    SNAP vt_11_04_02_08_03 f99e3933a767f5afc7dfe8e4f5090bea
    IN "\r"
    IN "9\r" # Test Cursor-Character-Absolute (CHA)
    SNAP vt_11_04_02_09_03 957d163801c93f87ed6431e384a0ebaa
    IN "\r"
    IN "10\r" # Test Cursor-Horizontal-Index (CHT)
    SNAP vt_11_04_02_10_03 f0e89a383b229068c1fc6b48726b2416
    IN "\r"
    IN "11\r" # Test Horizontal-Position-Relative (HPR)
    SNAP vt_11_04_02_11_03 1a213a6a43e4e92004d35a1eaba1ea91
    IN "\r"
    IN "12\r" # Test Line-Position-Absolute (VPA)
    SNAP vt_11_04_02_12_03 679760819243e0dd0b06a4ff8bf1f1c0
    IN "\r"
    IN "13\r" # Test Next-Line (CNL)
    SNAP vt_11_04_02_13_03 bcf27d65cae93e3bb102e689ec10e037
    IN "\r"
    IN "14\r" # Test Previous-Line (CPL)
    SNAP vt_11_04_02_14_03 938ec0882d8d14c33464e4f6d5cf9659
    IN "\r"
    IN "15\r" # Test Vertical-Position-Relative (VPR)
    SNAP vt_11_04_02_15_03 871e27f3e8e76fa856d700d2c97baa6c
    IN "\r"
    IN "4\r" # Top/Bottom margins are set to middle half of screen
    IN "7\r" # Test Character-Position-Absolute (HPA)
    SNAP vt_11_04_02_07_04 ffc5bf37378fad83c2ec431aaf16e755
    IN "\r"
    IN "8\r" # Test Cursor-Back-Tab (CBT)
    SNAP vt_11_04_02_08_04 b055dded8f76e98340de6c396d10be17
    IN "\r"
    IN "9\r" # Test Cursor-Character-Absolute (CHA)
    SNAP vt_11_04_02_09_04 6035a6bea6e4b8abe4d7f255072f452f
    IN "\r"
    IN "10\r" # Test Cursor-Horizontal-Index (CHT)
    SNAP vt_11_04_02_10_04 c35f9560e842fbd86204c18e0f5b848a
    IN "\r"
    IN "11\r" # Test Horizontal-Position-Relative (HPR)
    SNAP vt_11_04_02_11_04 eb4acbb81eae3d9194ea2ce3550a84d9
    IN "\r"
    IN "12\r" # Test Line-Position-Absolute (VPA)
    SNAP vt_11_04_02_12_04 3eac454041ada65cfa242cca0df5f098
    IN "\r"
    IN "13\r" # Test Next-Line (CNL)
    SNAP vt_11_04_02_13_04 09d717556f6aa0e4d0a33b940ec47d0c
    IN "\r"
    IN "14\r" # Test Previous-Line (CPL)
    SNAP vt_11_04_02_14_04 82aaa783015beeb19729860bfff82202
    IN "\r"
    IN "15\r" # Test Vertical-Position-Relative (VPR)
    SNAP vt_11_04_02_15_04 9d3978c2475c234d06d84e666334bcbd
    IN "\r"
    IN "4\r" # Top/Bottom margins are reset
    IN "3\r" # Enable DECLRMM (left/right mode)
    IN "5\r" # Left/right margins are set to left half of screen
    IN "7\r" # Test Character-Position-Absolute (HPA)
    SNAP vt_11_04_02_07_05 2cc0efb12ee31a027b31be975a9fd553
    IN "\r"
    IN "8\r" # Test Cursor-Back-Tab (CBT)
    SNAP vt_11_04_02_08_05 9675dba20496a8aeb9244072b5c67f71
    IN "\r"
    IN "9\r" # Test Cursor-Character-Absolute (CHA)
    SNAP vt_11_04_02_09_05 1b35a789114aa14cc340251aefb4f08a
    IN "\r"
    IN "10\r" # Test Cursor-Horizontal-Index (CHT)
    SNAP vt_11_04_02_10_05 56b77a9c8c1b272da7e4fc6077e7a7eb
    IN "\r"
    IN "11\r" # Test Horizontal-Position-Relative (HPR)
    SNAP vt_11_04_02_11_05 a5c597c6fc2b710ec7108e2516f7c183
    IN "\r"
    IN "12\r" # Test Line-Position-Absolute (VPA)
    SNAP vt_11_04_02_12_05 5539655f62fb58b4db7a13a82f5f6194
    IN "\r"
    IN "13\r" # Test Next-Line (CNL)
    SNAP vt_11_04_02_13_05 b7fbf0e53f05072ffdd795e80fb235c6
    IN "\r"
    IN "14\r" # Test Previous-Line (CPL)
    SNAP vt_11_04_02_14_05 c4778c3aa71d970016d9b8a3909bb285
    IN "\r"
    IN "15\r" # Test Vertical-Position-Relative (VPR)
    SNAP vt_11_04_02_15_05 2445a616ffbf71ac003113d1b8afcb1f
    IN "\r"
    IN "5\r" # Left/right margins are set to right half of screen
    IN "7\r" # Test Character-Position-Absolute (HPA)
    SNAP vt_11_04_02_07_06 91ee92e76475afc51aff4ecad22d192e
    IN "\r"
    IN "8\r" # Test Cursor-Back-Tab (CBT)
    SNAP vt_11_04_02_08_06 32333628529aa428d86ad601d9934935
    IN "\r"
    IN "9\r" # Test Cursor-Character-Absolute (CHA)
    SNAP vt_11_04_02_09_06 d1e4a1c2ecea0f94e2a332e90ac15755
    IN "\r"
    IN "10\r" # Test Cursor-Horizontal-Index (CHT)
    SNAP vt_11_04_02_10_06 4015dcfcac00a8b00c574cc4f31b05e8
    IN "\r"
    IN "11\r" # Test Horizontal-Position-Relative (HPR)
    SNAP vt_11_04_02_11_06 1544597973756c10a24eaf0b73ab4a66
    IN "\r"
    IN "12\r" # Test Line-Position-Absolute (VPA)
    SNAP vt_11_04_02_12_06 be898245c6ce6252a659cfb9927dc4bc
    IN "\r"
    IN "13\r" # Test Next-Line (CNL)
    SNAP vt_11_04_02_13_06 dbc235ce1d5a22bc0a6507fe8f6aa079
    IN "\r"
    IN "14\r" # Test Previous-Line (CPL)
    SNAP vt_11_04_02_14_06 052cd7a8e80e580be7c614992a190ea7
    IN "\r"
    IN "15\r" # Test Vertical-Position-Relative (VPR)
    SNAP vt_11_04_02_15_06 f4faff8acef012ba2e71a62d9ad9a3b4
    IN "\r"
    IN "5\r" # Left/right margins are set to middle half of screen
    IN "7\r" # Test Character-Position-Absolute (HPA)
    SNAP vt_11_04_02_07_07 50f91f4608c9de3fe13bcc80b7e5d0ce
    IN "\r"
    IN "8\r" # Test Cursor-Back-Tab (CBT)
    SNAP vt_11_04_02_08_07 797a724793967625e82e80547394d5a2
    IN "\r"
    IN "9\r" # Test Cursor-Character-Absolute (CHA)
    SNAP vt_11_04_02_09_07 4e2c23f0b1e1b48791ee7862cb9af550
    IN "\r"
    IN "10\r" # Test Cursor-Horizontal-Index (CHT)
    SNAP vt_11_04_02_10_07 f78c91326ab7e384433711441291edf5
    IN "\r"
    IN "11\r" # Test Horizontal-Position-Relative (HPR)
    SNAP vt_11_04_02_11_07 d20db184483edd54c3d02045acac0622
    IN "\r"
    IN "12\r" # Test Line-Position-Absolute (VPA)
    SNAP vt_11_04_02_12_07 9b6f7f7d115a92ece189f1c3ac37af21
    IN "\r"
    IN "13\r" # Test Next-Line (CNL)
    SNAP vt_11_04_02_13_07 157d10592fa03b8c74a93e6868c3320c
    IN "\r"
    IN "14\r" # Test Previous-Line (CPL)
    SNAP vt_11_04_02_14_07 d23d60f3a78e670841f4291d25889c2c
    IN "\r"
    IN "15\r" # Test Vertical-Position-Relative (VPR)
    SNAP vt_11_04_02_15_07 a94095b11d81eb466e686bebbe7be503
    IN "\r"
    IN "0\r"
    IN "0\r"

    # At this point we restart vttest, to avoid bumping into
    # a bug that produces a flawed input sequence for vt_11_06_04
    # resulting in wrong output (regardless of terminal emulator).
    echo "Restarting vttest to work-around bug in 11.6.4 ..."
    IN "0\r"
    IN "0\r"
    IN "vttest\r"
    IN "11\r"

    IN "6\r" # ISO 6429 colors
    IN "2\r" # Display color test-pattern
    SNAP vt_11_06_02 f8b3b32965a6e8d0d23105e97ccf4a04
    IN "\r"
    IN "3\r" # Test SGR-0 color reset
    SNAP vt_11_06_03 2c1bd3ad79d102140bac08d83e79ffb2
    IN "\r"
    IN "4\r" # Test BCE-style clear line/display (ED, EL)
    SNAP vt_11_06_04_01 70bfeab9636c666fba08359acf9686c8
    IN "\r"
    SNAP vt_11_06_04_02 937e8e04f0c1f7140b0fab203a857d78
    IN "\r"
    IN "5\r" # Test BCE-style clear line/display (ECH, Indexing)
    SNAP vt_11_06_05_01 70bfeab9636c666fba08359acf9686c8
    IN "\r"
    SNAP vt_11_06_05_02 937e8e04f0c1f7140b0fab203a857d78
    IN "\r"
    IN "6\r" # Test VT102-style features with BCE
    IN "1\r" # Test of cursor movements
    SNAP vt_11_06_06_01_01 26dbefebf10d11c3c964759806a6828a
    IN "\r"
    SNAP vt_11_06_06_01_02 0e35bc38d42c0814d4667626aeab7e8f
    IN "\r"
    SNAP vt_11_06_06_01_03 074e34257dba2756ae60794a6fed5197
    IN "\r"
    SNAP vt_11_06_06_01_04 074e34257dba2756ae60794a6fed5197
    IN "\r"
    SNAP vt_11_06_06_01_05 6174ed60205a68a323930cb930f21fca
    IN "\r"
    IN "2\r" # Test of screen features
    SNAP vt_11_06_06_02_01 c1f9acf183043a4fb4656812d6862f91
    IN "\r"
    SNAP vt_11_06_06_02_02 7052042cbae8834111c68bcaa709d9fe
    IN "\r"
    SNAP vt_11_06_06_02_03 1ba167a087be84e24054dff5aa4b2e1d
    IN "\r"
    SNAP vt_11_06_06_02_04 ee661af1e7d81555e0ec55ef2b7af675
    IN "\r"
    SNAP vt_11_06_06_02_05 31eefe09c1f65ed9f3582690c8ff879f
    IN "\r"
    SNAP vt_11_06_06_02_06 dc6de69d2f9e43c5925e27b8a8db7109
    IN "\r"
    SNAP vt_11_06_06_02_07 a9ffb6135b964fb2d97204a6528dca72
    IN "\r"
    SNAP vt_11_06_06_02_08 07b692efac56c848e359a0f4ab2317ff
    IN "\r"
    SNAP vt_11_06_06_02_09 6d63617053146d5418460c806b648342
    IN "\r"
    SNAP vt_11_06_06_02_10 d6121f604559f48b2510969c609e9a0e
    IN "\r"
    SNAP vt_11_06_06_02_11 be67d39b369b81e668a88c3a7e20ce0e
    IN "\r"
    SNAP vt_11_06_06_02_12 7164a54b192466ea188e847c4d485fce
    IN "\r"
    SNAP vt_11_06_06_02_13 9aaa71c2e7f7fbbb2f4337c8d082928e
    IN "\r"
    SNAP vt_11_06_06_02_14 58ff6c02c65d0af8bbc623f3a7f3d595
    IN "\r"
    IN "3\r" # Test Insert/Delete Char/Line
    SNAP vt_11_06_06_03_01 e397739950899c8988f835b48d81092a
    IN "\r"
    SNAP vt_11_06_06_03_02 557721d5e8643909e739ec65877886ef
    IN "\r"
    SNAP vt_11_06_06_03_03 3aa59a9aabe725eb5acf12a3896e26ef
    IN "\r"
    SNAP vt_11_06_06_03_04 92c3860a01714aedba5b1d7338e583e6
    IN "\r"
    SNAP vt_11_06_06_03_05 9d62aac15289861bb75ea2afff8d65e2
    IN "\r"
    SNAP vt_11_06_06_03_06 4fdb7bb8badc4fc7056789286ac787b4
    IN "\r"
    SNAP vt_11_06_06_03_07 89b6de168d25f81d4fd266499ddf57b3
    IN "\r"
    SNAP vt_11_06_06_03_08 dd72eafddd5e52b5a8fc610879a9e1cb
    IN "\r"
    SNAP vt_11_06_06_03_09 012b6f46c7062e51a14a782add1f932c
    IN "\r"
    SNAP vt_11_06_06_03_10 d6ab781a3286d7e2cf54cbcab05e8eae
    IN "\r"
    SNAP vt_11_06_06_03_11 cfae688a33ff74fec69eec932be1873e
    IN "\r"
    SNAP vt_11_06_06_03_12 d8d2eaadb3d52ca03a536d546e3a25a4
    IN "\r"
    SNAP vt_11_06_06_03_13 acec774fcdfcb42fb8e09e2cc4ee630d
    IN "\r"
    SNAP vt_11_06_06_03_14 ed712e1bafe7e94af2ae80394734677b
    IN "\r"
    SNAP vt_11_06_06_03_15 9e093affed49ace30e899c946a8c03f6
    IN "\r"
    SNAP vt_11_06_06_03_16 012b6f46c7062e51a14a782add1f932c
    IN "\r"
    IN "0\r"
    IN "7\r" # Miscellaneous ISO-6429 (ECMA-48) Tests
    IN "2\r" # Test Repeat (REP)
    SNAP vt_11_06_07_02 23ce64b3ffe224377e451e3a879d1e12
    IN "\r"
    IN "3\r" # Test Scroll-Down (SD)
    SNAP vt_11_06_07_03 fab146eb0298ecd2aef2bbe7f0dfc014
    IN "\r"
    IN "4\r" # Test Scroll-Left (SL)
    SNAP vt_11_06_07_04 301d884e39869f6b3760ded9110082bc
    IN "\r"
    IN "5\r" # Test Scroll-Right (SR)
    SNAP vt_11_06_07_05 0aa89dc4f1efb4fc43cf87177119bcba
    IN "\r"
    IN "6\r" # Test Scroll-Up (SU)
    SNAP vt_11_06_07_06 fe931ed1b1c19a96d67e6dad4d511048
    IN "\r"
    IN "0\r"
    IN "8\r" # Test screen features with BCE
    SNAP vt_11_06_08_01 a9ffb6135b964fb2d97204a6528dca72
    IN "\r"
    SNAP vt_11_06_08_02 07b692efac56c848e359a0f4ab2317ff
    IN "\r"
    SNAP vt_11_06_08_03 6d63617053146d5418460c806b648342
    IN "\r"
    SNAP vt_11_06_08_04 d6121f604559f48b2510969c609e9a0e
    IN "\r"
    SNAP vt_11_06_08_05 adb76f75b898b75cbcec13dbba11aeb8
    IN "\r"
    SNAP vt_11_06_08_06 b2051bf91da7f0cd878fb8796f7886ae
    IN "\r"
    IN "9\r" # Test screen features with ISO 6429 SGR 22-27 codes
    SNAP vt_11_06_09_01 e7245556fbb8e83eabb6367afe9e1d4a
    IN "\r"
    SNAP vt_11_06_09_02 4beb412613008422f3c399e445148d55
    IN "\r"
    SNAP vt_11_06_09_03 e7245556fbb8e83eabb6367afe9e1d4a
    IN "\r"
    IN "0\r"

    IN "7\r" # Miscellaneous ISO-6429 (ECMA-48) Tests
    IN "2\r" # Test Repeat (REP)
    SNAP vt_11_07_02 3445d34b2aabac0dc409eb1f02647caf
    IN "\r"
    IN "3\r" # Test Scroll-Down (SD)
    SNAP vt_11_07_03 e64c4ba22e13b98b6ec4382fff40a8ad
    IN "\r"
    IN "4\r" # Test Scroll-Left (SL)
    SNAP vt_11_07_04 1d4289aca279743ff6da2354bc2947e2
    IN "\r"
    IN "5\r" # Test Scroll-Right (SR)
    SNAP vt_11_07_05 8bc967fc1d05dad416777fdd7aaa893c
    IN "\r"
    IN "6\r" # Test Scroll-Up (SU)
    SNAP vt_11_07_06 cdfcbbaa82cfa4d1cd70b6aa59b3a524
    IN "\r"
    IN "0\r"

    IN "8\r" # XTERM special features
    IN "7\r" # Alternate-Screen features
    IN "1\r" # Switch to/from alternate screen
    IN "\r"
    IN "\r"
    SNAP vt_11_08_07_01 18cf109ae68ca289173ea212a3b35412
    IN "\r"

    IN "2\r" # Improved alternate screen
    IN "\r"
    IN "\r"
    SNAP vt_11_08_07_02 68af480a46befb984cb6cb76d35d5f36
    IN "\r"

    IN "3\r" # Better alternate screen
    IN "\r"
    IN "\r"
    SNAP vt_11_08_07_03 5b6a4af873eb55db67eb029a08328041
    IN "\r"

    IN "0\r"
    IN "0\r"
    IN "0\r"
}

setxkbmap us

IN "vttest\r"

VT_1
VT_2
VT_3
VT_5
VT_6
VT_7
VT_8
VT_9
VT_10
VT_11

IN "0\r"
