#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

# if [ -f $SOURCE_DIR/pomerol-$POMEROL_VERSION.tar.gz ]; then :; else
#   check wget -O $SOURCE_DIR/pomerol-$POMEROL_VERSION.tar.gz https://github.com/aeantipov/pomerol/archive/$POMEROL_VERSION.tar.gz
# fi

if [ -f $SOURCE_DIR/pomerol2dcore-$POMEROL2DCORE_VERSION.tar.gz ]; then :; else
  check wget -O $SOURCE_DIR/pomerol2dcore-$POMEROL2DCORE_VERSION.tar.gz https://github.com/j-otsuki/pomerol2dcore/archive/v$POMEROL2DCORE_VERSION.tar.gz
fi
