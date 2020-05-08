#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

ABICSVARS_SH=$PREFIX_APPS/abics/abicsvars-$ABICS_VERSION-$ABICS_MA_REVISION.sh
rm -f $PREFIX_APPS/abics/abicsvars.sh
ln -s $ABICSVARS_SH $PREFIX_APPS/abics/abicsvars.sh

