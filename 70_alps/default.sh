#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/alps-$ALPS_VERSION-$ALPS_MA_REVISION.log
PREFIX="$PREFIX_APPS/alps/alps-$ALPS_VERSION-$ALPS_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $BUILD_DIR/alps-build-$ALPS_VERSION $LOG
mkdir -p $BUILD_DIR/alps-build-$ALPS_VERSION
cd $BUILD_DIR/alps-build-$ALPS_VERSION
start_info | tee -a $LOG
echo "[cmake]" | tee -a $LOG
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DPYTHON_INTERPRETER=$PYTHON_ROOT/bin/python2.7 \
  -DHdf5_INCLUDE_DIRS=$HDF5_ROOT/include -DHdf5_LIBRARY_DIRS=$HDF5_ROOT/lib \
  -DALPS_ENABLE_OPENMP=ON -DALPS_ENABLE_OPENMP_WORKER=ON \
  -DALPS_BUILD_FORTRAN=ON -DALPS_BUILD_TESTS=ON -DALPS_BUILD_PYTHON=ON \
  -DBLAS_LIBRARY=-lblas -DLAPACK_LIBRARY=-llapack \
  $BUILD_DIR/alps-$ALPS_VERSION | tee -a $LOG

echo "[make]" | tee -a $LOG
check make -j2 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest]" | tee -a $LOG
ctest | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/alpsvars.sh
# alps $(basename $0 .sh) $ALPS_VERSION $ALPS_MA_REVISION $(date +%Y%m%d-%H%M%S)
. $PREFIX_TOOL/env.sh
. $PREFIX/bin/alpsvars.sh
EOF
ALPSVARS_SH=$PREFIX_APPS/alps/alpsvars-$ALPS_VERSION-$ALPS_MA_REVISION.sh
rm -f $ALPSVARS_SH
cp -f $BUILD_DIR/alpsvars.sh $ALPSVARS_SH
cp -f $LOG $PREFIX_APPS/alps
