#!/bin/bash
#PBS -q long
#PBS -N 740_ivy_noblank
# #PBS -l select=93:ncpus=16:model=san
# #PBS -l select=62:ncpus=24:model=has
#PBS -l select=74:ncpus=20:model=ivy
# #PBS -l select=53:ncpus=28:model=bro
# #PBS -l select=37:ncpus=40:model=sky_ele

#PBS -l walltime=120:00:00
#PBS -M anirban@caltech.edu
#PBS -m abe

cd $PBS_O_WORKDIR

# module purge
module load comp-intel/2016.2.181 mpi-sgi/mpt.2.14r19 hdf4/4.2.12 hdf5/1.8.18_mpt netcdf/4.4.1.1_mpt

echo "Running MITgcm"
mpiexec -n 1480 ./mitgcmuv
