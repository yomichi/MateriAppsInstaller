#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

# sh $SCRIPT_DIR/download.sh

cd $BUILD_DIR

## Alpscore_CTHYB_segment
SRCDIR=alpscore-cthyb-segment-$ALPSCORE_CTHYB_SEGMENT_VERSION
if [ -d ${SRCDIR} ] ; then :; else
  git clone https://github.com/ALPSCore/CT-HYB-SEGMENT alpscore-cthyb-segment-$ALPSCORE_CTHYB_SEGMENT_VERSION
  cd alpscore-cthyb-segment-$ALPSCORE_CTHYB_SEGMENT_VERSION
  git checkout $ALPSCORE_CTHYB_SEGMENT_VERSION
fi
