#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/pomerol-$POMEROL_VERSION-$POMEROL_MA_REVISION.log
rm -f $LOG

PREFIX="${PREFIX_APPS}/pomerol/pomerol-${POMEROL_VERSION}-${POMEROL_MA_REVISION}"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

CXX=`which g++`

sh $SCRIPT_DIR/setup.sh | tee -a $LOG

rm -rf $BUILD_DIR/pomerol-build-$POMEROL_VERSION
mkdir -p $BUILD_DIR/pomerol-build-$POMEROL_VERSION
cd $BUILD_DIR/pomerol-build-$POMEROL_VERSION
start_info | tee -a $LOG
echo "[cmake pomerol]" | tee -a $LOG
check cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DEIGEN3_INCLUDE_DIR=${EIGEN3_ROOT}/include/eigen3 \
  -DTesting=ON \
  -DProgs=ON \
  -DPOMEROL_COMPLEX_MATRIX_ELEMENTS=ON \
  -DPOMEROL_USE_OPENMP=ON \
  $BUILD_DIR/pomerol-$POMEROL_VERSION | tee -a $LOG
echo "[make pomerol]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install pomerol]" | tee -a $LOG
make install | tee -a $LOG

rm -rf $BUILD_DIR/pomerol2dcore-build-$POMEROL2DCORE_VERSION
mkdir -p $BUILD_DIR/pomerol2dcore-build-$POMEROL2DCORE_VERSION
cd $BUILD_DIR/pomerol2dcore-build-$POMEROL2DCORE_VERSION
echo "[cmake pomerol2dcore]" | tee -a $LOG
check cmake \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  _Dpomerol_DIR=$PREFIX/share/pomerol \
  $BUILD_DIR/pomerol2dcore-$POMEROL2DCORE_VERSION | tee -a $LOG
echo "[make pomerol2dcore]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install pomerol2dcore]" | tee -a $LOG
make install | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > ${BUILD_DIR}/pomerolvars.sh
# POMEROL $(basename $0 .sh) ${POMEROL_VERSION} ${POMEROL_MA_REVISION} $(date +%Y%m%d-%H%M%S)
. ${PREFIX_TOOL}/env.sh
export POMEROL_ROOT=$PREFIX
export PATH=\${POMEROL_ROOT}/bin:\$PATH
EOF
POMEROLVARS_SH=${PREFIX_APPS}/pomerol/pomerolvars-${POMEROL_VERSION}-${POMEROL_MA_REVISION}.sh
rm -f $POMEROLVARS_SH
cp -f ${BUILD_DIR}/pomerolvars.sh $POMEROLVARS_SH
cp -f $LOG ${PREFIX_APPS}/pomerol/
