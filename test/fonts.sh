#!/usr/bin/env bash

cd $(dirname $0)

# This test requires a set of fonts to be present.  See the comments
# above each test function on how to install them on a Debian system.
#
# Certain fonts are simply available via packages; others can be
# manually downloaded as an archive.  Some require further
# installation steps, outlined below.
#
# This test is a little bit special in that it starts up a new UUT
# instance for each snapshot - this is needed so we can hack the
# font-selection arguments in (plus, Zutty does not presently support
# any form of runtime font selection).
#
# Also, fonts might change in subtle ways and an altered hash does not
# necessarily indicate a bug. It merely serves as an indication of
# where manual inspection should be directed.
#
# For all the above reasons, this test is *not* run as part of run-ci,
# but it should nevertheless be manually run (and the results
# inspected) whenever touching the font rasterization code (font.cc).


ABORT_ON_MISMATCH=1


function CHECK {
    local snap_name="$1"; shift
    local snap_hash="$1"; shift

    export SNAP_NAME=${snap_name}
    export SNAP_HASH=${snap_hash}

    ./fonttest.sh
    [ $? -ne 0 ] && [ ${ABORT_ON_MISMATCH} -ne 0 ] && exit 1
}


function FONTS_MISC_FIXED {

    # Misc-fixed
    # Package: xfonts-base

    export UUT_ARGS="-font 6x13"
    CHECK font_MF_6x13 8d246d3884a8239185fb383a0fd225d5

    export UUT_ARGS="-font 7x13"
    CHECK font_MF_7x13 0af81203114d0bcc2a56663f2c6e6217

    export UUT_ARGS="-font 7x14"
    CHECK font_MF_7x14 237a03654d9a7b26681729f89ca03407

    export UUT_ARGS="-font 8x13"
    CHECK font_MF_8x13 52c870a4a3aabf1e5c36376ef57f51f1

    export UUT_ARGS="-font 9x15"
    CHECK font_MF_9x15 7e77a23386f94be8ed946c8cebc6aa2b

    export UUT_ARGS="-font 9x18"
    CHECK font_MF_9x18 777036fe9a03d25119d2014c9dc5e0f1
}

function FONTS_UW_T0 {

    # UW ttyp0
    # URL: https://people.mpi-inf.mpg.de/~uwe/misc/uw-ttyp0/uw-ttyp0-1.3.tar.gz
    #
    # After downloading and unpacking the archive under deps/fonts,
    # the font files need to be built:
    #   cd uw-ttyp0-1.3 && ./configure && make && cd ..
    #
    # Then, copy the generated Unicode-encoded files to discoverable names:
    #   for f in uw-ttyp0-1.3/genpcf/*-uni.pcf.gz
    #   do
    #       cp $f $(basename $(echo $f | sed 's/-uni//'))
    #   done

    export UUT_ARGS="-fontpath deps/fonts -font t0-11"
    CHECK font_T0_11 fd5a2046972752afec158b7fbbe08096

    export UUT_ARGS="-fontpath deps/fonts -font t0-12"
    CHECK font_T0_12 17e4810a994f1821016505cc06c60c73

    export UUT_ARGS="-fontpath deps/fonts -font t0-13"
    CHECK font_T0_13 182f24c03a1d15a6b460ad83c4b13778

    export UUT_ARGS="-fontpath deps/fonts -font t0-14"
    CHECK font_T0_14 ebbe0cfe64634d75be0cdd538dcc5411

    export UUT_ARGS="-fontpath deps/fonts -font t0-15"
    CHECK font_T0_15 1105fd60f66f6f705c9ac43bd264f292

    export UUT_ARGS="-fontpath deps/fonts -font t0-16"
    CHECK font_T0_16 86fb796b78406eb70120776ceaa80c7e

    export UUT_ARGS="-fontpath deps/fonts -font t0-17"
    CHECK font_T0_17 c7ababf5ed5c44e861f4702c15f52bdb

    export UUT_ARGS="-fontpath deps/fonts -font t0-18"
    CHECK font_T0_18 dbeda3398c43a63b7a28121a2b69efa3

    export UUT_ARGS="-fontpath deps/fonts -font t0-22"
    CHECK font_T0_22 7878692b24cd2907719d0c15d4081edf
}

function FONTS_LIBERATION_MONO {

    # Liberation Mono
    # Package: fonts-liberation

    export UUT_ARGS="-font LiberationMono -fontsize 12"
    CHECK font_LM_12 32c175c8da201bdf3dded9edc7da004c

    export UUT_ARGS="-font LiberationMono -fontsize 15"
    CHECK font_LM_15 f3401b9d683566a3b74ee009a5ea7a40

    export UUT_ARGS="-font LiberationMono -fontsize 18"
    CHECK font_LM_18 433a1c535e24b773c3ece547fc8c7b09

    export UUT_ARGS="-font LiberationMono -fontsize 21"
    CHECK font_LM_21 8f65c678e625d65615a174f39721df65

    export UUT_ARGS="-font LiberationMono -fontsize 24"
    CHECK font_LM_24 46b3f542582a5be78e038cf739cbe362

    export UUT_ARGS="-font LiberationMono -fontsize 27"
    CHECK font_LM_27 7f2e1e492b07af2923fbf709cb59a2c4

    export UUT_ARGS="-font LiberationMono -fontsize 30"
    CHECK font_LM_30 34581e35495b5cf525f9b9960ae826ce

    export UUT_ARGS="-font LiberationMono -fontsize 37"
    CHECK font_LM_37 393e02886a48ae67c7efdfd145405491
}

function FONTS_DEJA_VU_SANS_MONO {

    # Deja Vu Sans Mono
    # Package: fonts-dejavu-core

    export UUT_ARGS="-font DejaVuSansMono -fontsize 12"
    CHECK font_DV_12 baefc3e9032a41fc2ceda474ef97aa58

    export UUT_ARGS="-font DejaVuSansMono -fontsize 15"
    CHECK font_DV_15 ec67e96d3fec7c75ddd20f7e69d862ed

    export UUT_ARGS="-font DejaVuSansMono -fontsize 18"
    CHECK font_DV_18 ad4332c7d443f1dc187eb58304ff0a94

    export UUT_ARGS="-font DejaVuSansMono -fontsize 21"
    CHECK font_DV_21 b73fb4b4f180a2303e9861ec83f5945e

    export UUT_ARGS="-font DejaVuSansMono -fontsize 24"
    CHECK font_DV_24 6add6b25308eb81a9f33364532920b46

    export UUT_ARGS="-font DejaVuSansMono -fontsize 27"
    CHECK font_DV_27 f1f427aaf76c43415ecdc2d4743cd223

    export UUT_ARGS="-font DejaVuSansMono -fontsize 30"
    CHECK font_DV_30 6de6d6697f267a2b141ced3b4cece33b

    export UUT_ARGS="-font DejaVuSansMono -fontsize 37"
    CHECK font_DV_37 72dbe4037fc3d8a0dfe8a5e72c4eba93
}

function FONTS_FIRA_CODE {

    # Fira Code
    # URL: https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 12"
    CHECK font_FC_12 295c702fec817a215ac86045daec6721

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 15"
    CHECK font_FC_15 c138aa55f364d28af88c5b20d48d963d

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 18"
    CHECK font_FC_18 198306821bf68494dbbbb02dcc0049b7

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 21"
    CHECK font_FC_21 1755d1e8eda327595b8a1761452c9ea9

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 24"
    CHECK font_FC_24 2bf849d485c814f6ebf81f379580f980

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 27"
    CHECK font_FC_27 0827c36d644f540b0dad52967161e2aa

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 30"
    CHECK font_FC_30 57b4e505b471ba5cbf49c9e3c20be515

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 37"
    CHECK font_FC_37 338f9152853a37ae6408cb6528ee7783
}

function FONTS_JETBRAINS_MONO {

    # JetBrains Mono
    # URL: https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 12"
    CHECK font_JB_12 7101e8212d68fbd485ccef5872856464

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 15"
    CHECK font_JB_15 9573ec482c2d07d719e03a95bfe3af7f

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 18"
    CHECK font_JB_18 ed392f2b00d5f5ce18d85c849505dcad

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 21"
    CHECK font_JB_21 52ac9baff4675e0cb812656a536cc9ad

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 24"
    CHECK font_JB_24 3735478afb579687a4a299327d670949

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 27"
    CHECK font_JB_27 969b0714b2c03eb80ee2d2692febe448

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 30"
    CHECK font_JB_30 b7b8a286992f49c99b26dc4e21435b2c

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 37"
    CHECK font_JB_37 9492043c5d1acff58f72217cbe9a18da
}

function FONTS_SOURCE_CODE_PRO {

    # Source Code Pro
    # URL: https://github.com/adobe-fonts/source-code-pro/releases/download/2.042R-u%2F1.062R-i%2F1.026R-vf/TTF-source-code-pro-2.042R-u_1.062R-i.zip

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 12"
    CHECK font_SC_12 fc74b862b9cff04b305eadbc24389640

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 15"
    CHECK font_SC_15 68c8ec5d015246583805418bba091c56

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 18"
    CHECK font_SC_18 6bf6fb5a93c19f738f086661d825aeb5

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 21"
    CHECK font_SC_21 7ff68f817adf4d524c184b3579ae98ea

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 24"
    CHECK font_SC_24 1e9abe0371bfca1eae8c0b60cb1ba94b

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 27"
    CHECK font_SC_27 666ffd6a9e3ae71b4fc5e8a5ccdb7b9b

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 30"
    CHECK font_SC_30 d8338574a1b51d073f9edb614f74f1e6

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 37"
    CHECK font_SC_37 09af4a42956d42dbdf04e28364d6d38f
}

function FONTS_HASKLIG {

    # Hasklig
    # URL: https://github.com/i-tu/Hasklig/releases/download/v1.2/Hasklig-1.2.zip

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 12"
    CHECK font_HA_12 778bbdc88f650097b359adcb6b4f3158

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 15"
    CHECK font_HA_15 73e5d4f4843cdc03d06dcc3b10c74b3b

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 18"
    CHECK font_HA_18 1692f5879ad7d7419185bf0e683022a0

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 21"
    CHECK font_HA_21 b20845dfa07a827eb96b1346d140fdbd

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 24"
    CHECK font_HA_24 4b653b6a511ecfd03157e49653dcf935

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 27"
    CHECK font_HA_27 97a78068bc984343f0dbf29f506409ce

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 30"
    CHECK font_HA_30 19ee07f7420eae6f9c8823cd001a7fef

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 37"
    CHECK font_HA_37 709a1d6cfcf98a900452dd7de1375b36
}

function FONTS_FREEMONO {

    # Free Mono
    # Package: fonts-freemono-ttf

    export UUT_ARGS="-font FreeMono -fontsize 12"
    CHECK font_FM_12 717f82061c9ae3294b5704bab3e947b9

    export UUT_ARGS="-font FreeMono -fontsize 15"
    CHECK font_FM_15 f67534a3a91e4bf60a678da21d42b694

    export UUT_ARGS="-font FreeMono -fontsize 18"
    CHECK font_FM_18 7fb6a2cd946930cdec91257d2d04ce7d

    export UUT_ARGS="-font FreeMono -fontsize 21"
    CHECK font_FM_21 60ff731eaf96f8a46539d9ff4b98b0a4

    export UUT_ARGS="-font FreeMono -fontsize 24"
    CHECK font_FM_24 ae24bb01ea46966dbc1084d97fc54f48

    export UUT_ARGS="-font FreeMono -fontsize 27"
    CHECK font_FM_27 20dc47edd69d29a60b78dfb3fdc27e6a

    export UUT_ARGS="-font FreeMono -fontsize 30"
    CHECK font_FM_30 d0194498cf2330ca0acee865cfb8db68

    export UUT_ARGS="-font FreeMono -fontsize 37"
    CHECK font_FM_37 3a735d831e4653a27557baed7a91c560
}

function FONTS_ANONYMOUS_PRO {

    # Anonymous Pro
    # Package: fonts-anonymous-pro
    #
    # After installing, copy the font files to more convenient names:
    #   for f in /usr/share/fonts/truetype/anonymous-pro/*.ttf
    #   do
    #       cp "$f" $(basename $(echo $f | sed 's/ //g'))
    #   done

    # N.B.: Size 12 is a bitmap face that does not seem to work well ATM

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 15"
    CHECK font_AP_15 f189a3a4b295523dcc8069755d3aad34

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 18"
    CHECK font_AP_18 2918a39cea1739c319957c0451feeee9

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 21"
    CHECK font_AP_21 6120643b09f9a923764107243faaf432

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 24"
    CHECK font_AP_24 2d2aea7a72b1662cde7c1bd22b46ce9f

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 27"
    CHECK font_AP_27 34e670ad7a8fb66b7ca70a0604752081

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 30"
    CHECK font_AP_30 eabb709c604cfd93606d54e7edcf8fd7

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 37"
    CHECK font_AP_37 0c2df9fac7481ce687a52bc9acc94574
}

FONTS_MISC_FIXED
FONTS_UW_T0

FONTS_LIBERATION_MONO
FONTS_DEJA_VU_SANS_MONO
FONTS_FIRA_CODE
FONTS_JETBRAINS_MONO
FONTS_SOURCE_CODE_PRO
FONTS_HASKLIG
FONTS_FREEMONO
FONTS_ANONYMOUS_PRO
