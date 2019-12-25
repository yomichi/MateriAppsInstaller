#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

POMEROLVARS_SH=$PREFIX_APPS/pomerol/pomerolvars-$POMEROL_VERSION-$POMEROL_MA_REVISION.sh
rm -f $PREFIX_APPS/pomerol/pomerolvars.sh
ln -sf $POMEROLVARS_SH $PREFIX_APPS/pomerol/pomerolvars.sh

