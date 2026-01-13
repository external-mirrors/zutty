#!/usr/bin/env bash

cd $(dirname $0)
source testbase.sh

which wraptest >/dev/null
if [ $? -gt 0 ] ; then
    printf "${YELLOW}Please run test/deps/install_wraptest.sh${DFLT}\n"
fi
CHECK_DEPS wraptest

IN "wraptest | head -23 && sleep 2\r"
SNAP wraptest_01 92217dbf8b571f9a1b3f5d6029f8afc9

IN "wraptest | tail -23 && sleep 2\r"
SNAP wraptest_02 3589f0bef5073b0bcb77a132342b5332

IN "source wraptest_inc.sh\r"
SNAP wraptest_03 88d4b5e5a139398ccb02e2e002183b7a

IN "\r"
SNAP wraptest_04 19d1f6c6941ef96c15d6360d45d66ecf
