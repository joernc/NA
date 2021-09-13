#!/bin/bash
export MITGCMROOT="/nobackup/asinha5/MITgcm"

cd build_high/
module load comp-intel/2016.2.181 mpi-sgi/mpt.2.14r19 hdf4/4.2.12 hdf5/1.8.18_mpt netcdf/4.4.1.1_mpt
$MITGCMROOT/tools/genmake2 -mods=/nobackup/asinha5/NA/experiments/ll2960_02/code_high/ -optfile=$MITGCMROOT/tools/build_options/linux_amd64_ifort+mpi_ice_nas -mpi -rootdir=$MITGCMROOT

make depend
make -j 200

