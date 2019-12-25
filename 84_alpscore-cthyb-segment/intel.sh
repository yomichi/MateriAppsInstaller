#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/alpscore-cthyb-segment-$ALPSCORE_CTHYB_SEGMENT_VERSION-$ALPSCORE_CTHYB_SEGMENT_MA_REVISION.log

source $PREFIX_APPS/triqs/triqsvars.sh

CC=`which icc`
CXX=`which icpc`

PREFIX="$PREFIX_APPS/alpscore-cthyb-segment/alpscore-cthyb-segment-$ALPSCORE_CTHYB_SEGMENT_VERSION-$ALPSCORE_CTHYB_SEGMENT_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

rm -f $LOG
sh $SCRIPT_DIR/setup.sh | tee -a $LOG

## ALPSCORE_CTHYB
rm -rf $BUILD_DIR/alpscore-cthyb-segment-build-$ALPSCORE_CTHYB_SEGMENT_VERSION
mkdir -p $BUILD_DIR/alpscore-cthyb-segment-build-$ALPSCORE_CTHYB_SEGMENT_VERSION
cd $BUILD_DIR/alpscore-cthyb-segment-build-$ALPSCORE_CTHYB_SEGMENT_VERSION
start_info | tee -a $LOG
echo "[cmake alpscore/CT-HYB-segment]" | tee -a $LOG
check cmake \
  -DCMAKE_C_COMPILER=$CC \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DNFFT3_DIR=${NFFT_ROOT} \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_CXX_FLAGS="-std=c++11" \
  -DALPSCore_DIR=${ALPSCORE_ROOT}/share/ALPSCore \
  $BUILD_DIR/alpscore-cthyb-segment-$ALPSCORE_CTHYB_SEGMENT_VERSION | tee -a $LOG
echo "[make alpscore/CT-HYB-segment]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install alpscore/CT-HYB-segment]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest alpscore/CT-HYB-segment]" | tee -a $LOG
ctest | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/alpscore-cthyb-segmentvars.sh
# alpscore-cthyb-segment $(basename $0 .sh) $ALPSCORE_CTHYB_SEGMENT_VERSION $ALPSCORE_CTHYB_SEGMENT_MA_REVISION $(date +%Y%m%d-%H%M%S)
. $PREFIX_TOOL/env.sh
export ALPSCORE_CTHYB_ROOT=$PREFIX
export PATH=\$ALPSCORE_CTHYB_SEGMENT_ROOT/bin:\$PATH
EOF
ALPSCORE_CTHYBVARS_SH=$PREFIX_APPS/alpscore-cthyb-segment/alpscore-cthyb-segmentvars-$ALPSCORE_CTHYB_SEGMENT_VERSION-$ALPSCORE_CTHYB_SEGMENT_MA_REVISION.sh
rm -f $ALPSCORE_CTHYBVARS_SH
cp -f $BUILD_DIR/alpscore-cthyb-segmentvars.sh $ALPSCORE_CTHYBVARS_SH
cp -f $LOG $PREFIX_APPS/alpscore-cthyb-segment/
