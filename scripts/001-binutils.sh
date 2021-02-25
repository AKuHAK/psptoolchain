#!/bin/bash
# 001-binutils.sh by Francisco Javier Trujillo Mata (fjtrujy@gmail.com)

## Download the source code.
REPO_URL="https://github.com/pspdev/binutils.git"
REPO_FOLDER="binutils"
BRANCH_NAME="master"
if test ! -d "$REPO_FOLDER"; then
	git clone --depth 1 -b $BRANCH_NAME $REPO_URL && cd $REPO_FOLDER || exit 1
else
	cd $REPO_FOLDER && git fetch origin && git reset --hard origin/${BRANCH_NAME} || exit 1
fi

TARGET="psp"
TARG_XTRA_OPTS=""

## Determine the maximum number of processes that Make can work with.
PROC_NR=$(getconf _NPROCESSORS_ONLN)

## Create and enter the toolchain/build directory
rm -rf build-$TARGET && mkdir build-$TARGET && cd build-$TARGET || { exit 1; }

## Configure the build.
../configure \
  --quiet \
  --prefix="$PSPDEV" \
  --target="$TARGET" \
  --enable-plugins \
  --disable-nls \
  --disable-separate-code \
  --disable-sim \
  --disable-werror \
  --disable-docs \
  $TARG_XTRA_OPTS || { exit 1; }

cat Makefile

## Compile and install.
make --quiet -j $PROC_NR clean || { exit 1; }
make --quiet -j $PROC_NR || { exit 1; }
make --quiet -r -j $PROC_NR install-strip || { exit 1; } # MAKEINF=true for disable docs isn't compiling in Alpine
make --quiet -j $PROC_NR clean || { exit 1; }