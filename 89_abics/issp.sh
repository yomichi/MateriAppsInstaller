#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh

PREFIX="${PREFIX_APPS}/abics/abics-${ABICS_VERSION}-${ABICS_MA_REVISION}"
sh ${SCRIPT_DIR}/default.sh

ABICSVARS_SH=${PREFIX_APPS}/abics/abicsvars-${ABICS_VERSION}-${ABICS_MA_REVISION}.sh

cp ${PREFIX}/bin/abics ${PREFIX}/bin/abics_nocount
cat << EOF > ${PREFIX}/bin/abics
#!/bin/sh
source ${ABICSVARS_SH}
/home/issp/materiapps/tool/bin/issp-ucount abics
${PREFIX}/bin/abics_nocount \$@
EOF
chmod +x ${PREFIX}/bin/abics

