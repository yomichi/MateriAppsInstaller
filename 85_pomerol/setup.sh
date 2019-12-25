#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR
# if [ -d pomerol-$POMEROL_VERSION ]; then :; else
#   check mkdir -p pomerol-$POMEROL_VERSION
#   check tar zxf $SOURCE_DIR/pomerol-$POMEROL_VERSION.tar.gz -C pomerol-$POMEROL_VERSION --strip-components=1
#   if [ -f $SCRIPT_DIR/pomerol-$POMEROL_VERSION.patch ]; then
#     cd pomerol-$POMEROL_VERSION
#     patch -p1 < $SCRIPT_DIR/pomerol-$POMEROL_VERSION.patch
#   fi
# fi

rm -rf pomerol-$POMEROL_VERSION
git clone https://github.com/aeantipov/pomerol pomerol-$POMEROL_VERSION
cd pomerol
git checkout $POMEROL_VERSION

cd $BUILD_DIR
if [ -d pomerol2dcore-$POMEROL2DCORE_VERSION ]; then :; else
  check mkdir -p pomerol2dcore-$POMEROL2DCORE_VERSION
  check tar zxf $SOURCE_DIR/pomerol2dcore-$POMEROL2DCORE_VERSION.tar.gz -C pomerol2dcore-$POMEROL2DCORE_VERSION --strip-components=1
  if [ -f $SCRIPT_DIR/pomerol2dcore-$POMEROL2DCORE_VERSION.patch ]; then
    cd pomerol2dcore-$POMEROL2DCORE_VERSION
    patch -p1 < $SCRIPT_DIR/pomerol2dcore-$POMEROL2DCORE_VERSION.patch
  fi
fi
