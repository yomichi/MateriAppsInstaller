#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/abics-$ABICS_VERSION-$ABICS_MA_REVISION.log
rm -f $LOG

PREFIX="${PREFIX_APPS}/abics/abics-${ABICS_VERSION}-${ABICS_MA_REVISION}"

CXX=icpc

if [ -f $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

PYTHONVERSION=`python3 -V | cut -d ' ' -f2 | cut -d '.' -f1,2`

sh $SCRIPT_DIR/setup.sh | tee -a $LOG

start_info | tee -a $LOG

python3 -m pip install --prefix=${PREFIX} abics==${ABICS_VERSION} | tee -a $LOG

cp -r $BUILD_DIR/abics-$ABICS_VERSION/examples ${PREFIX}/

finish_info | tee -a $LOG

ABICSVARS_SH=${PREFIX_APPS}/abics/abicsvars-${ABICS_VERSION}-${ABICS_MA_REVISION}.sh

cat << EOF > ${BUILD_DIR}/abicsvars.sh
# abics $(basename $0 .sh) ${ABICS_VERSION} ${ABICS_MA_REVISION} $(date +%Y%m%d-%H%M%S)
. ${PREFIX_TOOL}/env.sh
. $TRIQSVARS
export ABICS_ROOT=$PREFIX
export PATH=\${ABICS_ROOT}/bin:\$PATH
export PYTHONPATH=\${ABICS_ROOT}/lib/python${PYTHONVERSION}:\$PYTHONPATH
EOF
rm -f $ABICSVARS_SH
cp -f ${BUILD_DIR}/abicsvars.sh $ABICSVARS_SH
cp -f $LOG ${PREFIX_APPS}/abics/
