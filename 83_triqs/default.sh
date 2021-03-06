#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/triqs-$TRIQS_VERSION-$TRIQS_MA_REVISION.log

CC=gcc
CXX=g++

PREFIX="$PREFIX_APPS/triqs/triqs-$TRIQS_VERSION-$TRIQS_MA_REVISION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

rm -f $LOG
sh $SCRIPT_DIR/setup.sh | tee -a $LOG

echo "[install mako]" | tee -a $LOG
check pip install mako | tee -a $LOG
echo "[install h5py]" | tee -a $LOG
check pip install --global-option=build_ext --global-option="-I$HDF5_ROOT/include" --global-option="-L$HDF5_ROOT/lib" h5py | tee -a $LOG
echo "[install mpi4py]" | tee -a $LOG
check pip install mpi4py | tee -a $LOG

## TRIQS
rm -rf $BUILD_DIR/triqs-build-$TRIQS_VERSION
mkdir -p $BUILD_DIR/triqs-build-$TRIQS_VERSION
cd $BUILD_DIR/triqs-build-$TRIQS_VERSION
start_info | tee -a $LOG
echo "[cmake TRIQS]" | tee -a $LOG
check cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_C_COMPILER=$CC \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DCMAKE_CXX_FLAGS="-std=c++1y" \
  $BUILD_DIR/triqs-$TRIQS_VERSION | tee -a $LOG
echo "[make TRIQS]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install TRIQS]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest TRIQS]" | tee -a $LOG
ctest | tee -a $LOG

## TRIQS-CTHyb
rm -rf $BUILD_DIR/triqs-cthyb-build-$TRIQS_CTHYB_VERSION
mkdir -p $BUILD_DIR/triqs-cthyb-build-$TRIQS_CTHYB_VERSION
cd $BUILD_DIR/triqs-cthyb-build-$TRIQS_CTHYB_VERSION
start_info | tee -a $LOG
echo "[cmake TRIQS-CTHyb]" | tee -a $LOG
check cmake \
  -DCMAKE_C_COMPILER=$CC \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DCMAKE_CXX_FLAGS="-std=c++1y" \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DTRIQS_PATH=$PREFIX \
  -DHYBRIDISATION_IS_COMPLEX=ON \
  -DLOCAL_HAMILTONIAN_IS_COMPLEX=ON \
  $BUILD_DIR/triqs-cthyb-$TRIQS_CTHYB_VERSION | tee -a $LOG
echo "[make TRIQS-CTHyb]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install TRIQS-CTHyb]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest TRIQS-CTHyb]" | tee -a $LOG
ctest | tee -a $LOG

## TRIQS-DFTTools
rm -rf $BUILD_DIR/triqs-dfttools-build-$TRIQS_DFTTOOLS_VERSION
mkdir -p $BUILD_DIR/triqs-dfttools-build-$TRIQS_DFTTOOLS_VERSION
cd $BUILD_DIR/triqs-dfttools-build-$TRIQS_DFTTOOLS_VERSION
start_info | tee -a $LOG
echo "[cmake TRIQS-DFTTools]" | tee -a $LOG
check cmake \
  -DCMAKE_C_COMPILER=$CC \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DCMAKE_CXX_FLAGS="-std=c++1y" \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DTRIQS_PATH=$PREFIX \
  $BUILD_DIR/triqs-dfttools-$TRIQS_DFTTOOLS_VERSION | tee -a $LOG
echo "[make TRIQS-DFTTools]" | tee -a $LOG
check make -j4 | tee -a $LOG
echo "[make install TRIQS-DFTTools]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest TRIQS-DFTTools]" | tee -a $LOG
ctest | tee -a $LOG

## TRIQS-HubbardI
rm -rf $BUILD_DIR/triqs-hubbardI-build-$TRIQS_HUBBARDI_VERSION
mkdir -p $BUILD_DIR/triqs-hubbardI-build-$TRIQS_HUBBARDI_VERSION
cd $BUILD_DIR/triqs-hubbardI-build-$TRIQS_HUBBARDI_VERSION
start_info | tee -a $LOG
echo "[cmake TRIQS-HubbardI]" | tee -a $LOG
check cmake \
  -DCMAKE_C_COMPILER=$CC \
  -DCMAKE_CXX_COMPILER=$CXX \
  -DCMAKE_CXX_FLAGS="-std=c++1y" \
  -DCMAKE_VERBOSE_MAKEFILE=ON \
  -DTRIQS_PATH=$PREFIX \
  $BUILD_DIR/triqs-hubbardI-$TRIQS_HUBBARDI_VERSION | tee -a $LOG
echo "[make TRIQS-HubbardI]" | tee -a $LOG
check make | tee -a $LOG
echo "[make install TRIQS-HubbardI]" | tee -a $LOG
make install | tee -a $LOG
echo "[ctest TRIQS-HubbardI]" | tee -a $LOG
ctest | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/triqsvars.sh
# triqs $(basename $0 .sh) $TRIQS_VERSION $TRIQS_MA_REVISION $(date +%Y%m%d-%H%M%S)
. $PREFIX_TOOL/env.sh
export TRIQS_ROOT=$PREFIX
export PATH=\$TRIQS_ROOT/bin:\$PATH
EOF
TRIQSVARS_SH=$PREFIX_APPS/triqs/triqsvars-$TRIQS_VERSION-$TRIQS_MA_REVISION.sh
rm -f $TRIQSVARS_SH
cp -f $BUILD_DIR/triqsvars.sh $TRIQSVARS_SH
cp -f $LOG $PREFIX_APPS/triqs/
