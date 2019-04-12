#!/bin/bash

module load intel/19.1
#module load intel/18.1
#module load openmpi/3.1.2_intel-18.1
cd build/

# $MITGCMROOT/tools/genmake2 -rootdir=$MITGCMROOT -mods=/central/groups/oceanphysics/anirban/NA/experiments/ll1815_02/code -mpi -of=$MITGCMROOT/tools/build_options/linux_amd64_ifort+impi
$MITGCMROOT/tools/genmake2 -mods=/central/groups/oceanphysics/anirban/NA/experiments/ll1815_06/code/ -optfile=$MITGCMROOT/tools/build_options/linux_amd64_ifort+impi -mpi -rootdir=$MITGCMROOT

make depend
make -j 16

