#!/bin/bash
#PBS -q long
#PBS -N 370_ivy
# #PBS -l select=43:ncpus=16:model=san
# #PBS -l select=29:ncpus=24:model=has
#PBS -l select=35:ncpus=20:model=ivy
# #PBS -l select=25:ncpus=28:model=bro
# #PBS -l select=18:ncpus=40:model=sky_ele

#PBS -l walltime=18:00:00
#PBS -M anirban@caltech.edu
#PBS -m abe

cd $PBS_O_WORKDIR

# module purge
module load comp-intel/2016.2.181 mpi-sgi/mpt.2.14r19 hdf4/4.2.12 hdf5/1.8.18_mpt netcdf/4.4.1.1_mpt

echo "Running MITgcm"
mpiexec -n 686 ./mitgcmuv

# ./most_recent_pickup.sh
# qsub $0
