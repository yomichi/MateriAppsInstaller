SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)
. $SCRIPT_DIR/../util.sh
. $SCRIPT_DIR/version.sh
set_prefix

. $PREFIX_TOOL/env.sh
LOG=$BUILD_DIR/mVMC-$MVMC_VERSION-$MVMC_PATCH_VERSION.log

PREFIX="$PREFIX_APPS/mVMC/mVMC-$MVMC_VERSION-$MVMC_PATCH_VERSION"

if [ -d $PREFIX ]; then
  echo "Error: $PREFIX exists"
  exit 127
fi

sh $SCRIPT_DIR/setup.sh
rm -rf $LOG
cd $BUILD_DIR/mVMC-$MVMC_VERSION
start_info | tee -a $LOG
echo "[make]" | tee -a $LOG
if [ -e makefile ]; then
    check make veryclean | tee -a $LOG
fi
check sh ./mVMCconfig.sh kei
check make mvmc | tee -a $LOG
echo "[make install]" | tee -a $LOG

echo "mkdir -p $PREFIX/bin" | tee -a $LOG
mkdir -p $PREFIX/bin | tee -a $LOG

echo "cp src/mVMC/vmc.out ${PREFIX}/bin" | tee -a $LOG
cp src/mVMC/vmc.out ${PREFIX}/bin
echo "cp src/mVMC/vmcdry.out ${PREFIX}/bin" | tee -a $LOG
cp src/mVMC/vmcdry.out ${PREFIX}/bin
echo "cp src/ComplexUHF/UHF ${PREFIX}/bin" | tee -a $LOG
cp src/ComplexUHF/UHF ${PREFIX}/bin
echo "cp tool/fourier ${PREFIX}/bin" | tee -a $LOG
cp tool/fourier ${PREFIX}/bin
echo "cp tool/corplot ${PREFIX}/bin" | tee -a $LOG
cp tool/corplot ${PREFIX}/bin

echo "cp -r sample ${PREFIX}" | tee -a $LOG
cp -r sample ${PREFIX}

echo "mkdir -p ${PREFIX}/doc" | tee -a $LOG
mkdir -p $PREFIX/doc | tee -a $LOG
echo "cp userguide_jp.pdf ${PREFIX}/doc" | tee -a $LOG
cp userguide_jp.pdf ${PREFIX}/doc/ | tee -a $LOG
echo "cp userguide_en.pdf ${PREFIX}/doc" | tee -a $LOG
cp userguide_en.pdf ${PREFIX}/doc/ | tee -a $LOG

finish_info | tee -a $LOG

cat << EOF > $BUILD_DIR/mVMCvars.sh
. $PREFIX_TOOL/env.sh
export MVMC_ROOT=$PREFIX
export PATH=\$MVMC_ROOT/bin:\$PATH
EOF
MVMCVARS_SH=$PREFIX_APPS/mVMC/mVMCvars-$MVMC_VERSION-$MVMC_PATCH_VERSION.sh
rm -f $MVMCVARS_SH
cp -f $BUILD_DIR/mVMCvars.sh $MVMCVARS_SH
cp -f $LOG $PREFIX_APPS/mVMC
