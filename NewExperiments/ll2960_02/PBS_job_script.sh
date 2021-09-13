#!/bin/bash
#PBS -q long 
#PBS -N 2960_sky_high
# #PBS -l select=337:ncpus=16:model=san
# #PBS -l select=225:ncpus=24:model=has
# #PBS -l select=270:ncpus=20:model=ivy
# #PBS -l select=193:ncpus=28:model=bro
#PBS -l select=135:ncpus=40:model=sky_ele

#PBS -l walltime=48:00:00
#PBS -M anirban@caltech.edu
#PBS -m abe

cd $PBS_O_WORKDIR

# module purge
module load comp-intel/2016.2.181 mpi-sgi/mpt.2.14r19 hdf4/4.2.12 hdf5/1.8.18_mpt netcdf/4.4.1.1_mpt

echo "Running MITgcm"
mpiexec -n 5385 ./mitgcmuv
# ./most_recent_pickup.sh
# qsub $0
