#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

DSQSSVARS_SH=$PREFIX_APPS/dsqss/dsqssvars-$DSQSS_VERSION-$DSQSS_MA_REVISION.sh
rm -f $PREFIX_APPS/dsqss/dsqssvars.sh
ln -s $DSQSSVARS_SH $PREFIX_APPS/dsqss/dsqssvars.sh

BUILD_ARCH="Linux-x86_64 Linux-s64fx"
for arch in $BUILD_ARCH; do
  DSQSSVARS_SH=$PREFIX_APPS/dsqss/dsqssvars-$arch-$DSQSS_VERSION-$DSQSS_MA_REVISION.sh
  if [ -f $DSQSSVARS_SH ]; then
    rm -f $PREFIX_APPS/dsqss/dsqssvars-$arch.sh
    ln -s $DSQSSVARS_SH $PREFIX_APPS/dsqss/dsqssvars-$arch.sh
  fi
done
