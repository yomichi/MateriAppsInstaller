#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
set_prefix
. $PREFIX_TOOL/env.sh
. $SCRIPT_DIR/version.sh

WXWIDGETSVARS_SH=$PREFIX_TOOL/wxWidgets/wxWidgetsvars-$WXWIDGETS_VERSION-$WXWIDGETS_MA_REVISION.sh
rm -f $PREFIX_TOOL/env.d/wxWidgetsvars.sh
ln -s $WXWIDGETSVARS_SH $PREFIX_TOOL/env.d/wxWidgetsvars.sh
