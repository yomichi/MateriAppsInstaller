#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/scalapack-$SCALAPACK_VERSION-$SCALAPACK_MA_REVISION.log

PREFIX="$PREFIX_TOOL/scalapack/scalapack-$SCALAPACK_VERSION-$SCALAPACK_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh

mkdir -p $BUILD_DIR/scalapack-$SCALAPACK_VERSION-build
cd $BUILD_DIR/scalapack-$SCALAPACK_VERSION-build
start_info | tee $LOG
echo "[cmake]" | tee -a $LOG
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_C_COMPILER=mpicc -DCMAKE_Fortran_COMPILER=mpif90 \
  -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF \
  -DLAPACK_LIBRARIES="-Wl,-framework -Wl,Accelerate" \
  -DCMAKE_INSTALL_RPATH="$PREFIX/lib" -DCMAKE_SKIP_BUILD_RPATH=OFF -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON -DCMAKE_MACOSX_RPATH=1 \
  $BUILD_DIR/scalapack-$SCALAPACK_VERSION | tee -a $LOG
echo "[make]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install]" | tee -a $LOG
make install | tee -a $LOG
finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/scalapackvars.sh
# scalapack $(basename $0 .sh) $SCALAPACK_VERSION $SCALAPACK_MA_REVISION $(date +%Y%m%d-%H%M%S)
export SCALAPACK_ROOT=$PREFIX
export LD_LIBRARY_PATH=\$SCALAPACK_ROOT/lib:\$LD_LIBRARY_PATH
EOF
SCALAPACKVARS_SH=$PREFIX_TOOL/scalapack/scalapackvars-$SCALAPACK_VERSION-$SCALAPACK_MA_REVISION.sh
rm -f $SCALAPACKVARS_SH
cp -f $BUILD_DIR/scalapackvars.sh $SCALAPACKVARS_SH
cp -f $LOG $PREFIX_TOOL/scalapack/
