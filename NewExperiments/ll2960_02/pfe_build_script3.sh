#!/bin/bash
export MITGCMROOT="/nobackup/asinha5/MITgcm"

cd build_high3/
module load comp-intel/2016.2.181 
module load mpi-sgi/mpt.2.14r19 
module load hdf4/4.2.12 
module load hdf5/1.8.18_mpt 
module load netcdf/4.4.1.1_mpt
$MITGCMROOT/tools/genmake2 -mods=/nobackup/asinha5/NA/experiments/ll2960_02/code_high3/ -optfile=$MITGCMROOT/tools/build_options/linux_amd64_ifort+mpi_ice_nas -mpi -rootdir=$MITGCMROOT

make depend
make -j 200

