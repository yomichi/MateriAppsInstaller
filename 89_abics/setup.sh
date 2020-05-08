#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
if [ -d abics-$ABICS_VERSION ]; then :; else
  check mkdir -p abics-$ABICS_VERSION
  check tar zxf $SOURCE_DIR/abics-$ABICS_VERSION.tar.gz -C abics-$ABICS_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/abics-$ABICS_VERSION.patch ]; then
    cd abics-$ABICS_VERSION
    patch -p1 < $SCRIPT_DIR/abics-$ABICS_VERSION.patch
  fi
fi
