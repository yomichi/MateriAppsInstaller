#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ALPSCORE_CTHYB_SEGMENTVARS_SH=$PREFIX_APPS/alpscore-cthyb-segment/alpscore-cthyb-segmentvars-$ALPSCORE_CTHYB_SEGMENT_VERSION-$ALPSCORE_CTHYB_SEGMENT_MA_REVISION.sh
rm -f $PREFIX_APPS/alpscore-cthyb-segment/alpscore-cthyb-segmentvars.sh
ln -s $ALPSCORE_CTHYB_SEGMENTVARS_SH $PREFIX_APPS/alpscore-cthyb-segment/alpscore-cthyb-segmentvars.sh
