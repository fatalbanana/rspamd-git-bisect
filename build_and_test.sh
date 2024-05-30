#!/bin/bash

rm -rf ${GITHUB_WORKSPACE}/build ${GITHUB_WORKSPACE}/install
mkdir -p ${GITHUB_WORKSPACE}/build ${GITHUB_WORKSPACE}/install
cd ${GITHUB_WORKSPACE}/build
cmake -DCMAKE_INSTALL_PREFIX=${GITHUB_WORKSPACE}/install -DCMAKE_RULE_MESSAGES=OFF -DCMAKE_VERBOSE_MAKEFILE=ON -DENABLE_COVERAGE=ON -DENABLE_LIBUNWIND=ON -DENABLE_HYPERSCAN=ON -GNinja ${GITHUB_WORKSPACE}/src
ncpu=$(getconf _NPROCESSORS_ONLN)
ninja -j $ncpu install
ninja -j $ncpu rspamd-test
ninja -j $ncpu rspamd-test-cxx
RSPAMD_INSTALLROOT=${GITHUB_WORKSPACE}/install robot -t '*4981*' -v RSPAMD_USER:root -v RSPAMD_GROUP:root --removekeywords wuks --exclude isbroken ${GITHUB_WORKSPACE}/src/test.orig/functional/cases
