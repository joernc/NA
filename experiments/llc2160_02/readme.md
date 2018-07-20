# Get NA configuration files from GitHub
# For instructions below to work, you need to:
# (1) have a github account
# (2) have been granted access to
#     https://github.com/joernc/NA
# (3) have added ssh key to your github account
#     https://help.github.com/articles/generating-an-ssh-key
 cd /nobackup/$USER
 git clone git@github.com:joernc/NA

# Get MITgcm from GitHub
 cd /nobackup/$USER/NA
#- method 1, using https:
 git clone https://github.com/MITgcm/MITgcm.git
#- method 2, using ssh (requires a github account):
 git clone git@github.com:MITgcm/MITgcm.git

# Request interactive nodes
 qsub -I -q debug -l select=8:ncpus=20:model=ivy,walltime=2:00:00 -m abe

# Compile MITgcm
 cd /nobackup/$USER/NA/MITgcm
 mkdir build run
 cd /nobackup/$USER/NA/MITgcm/build
 module load comp-intel/2016.2.181 mpi-sgi/mpt.2.14r19 hdf4/4.2.12 hdf5/1.8.18_mpt netcdf/4.4.1.1_mpt
 ../tools/genmake2 -of ../tools/build_options/linux_amd64_ifort+mpi_ice_nas -mpi -mods ../../code 
 make depend
 make -j 16

# Run MITgcm
 cd /nobackup/$USER/NA/MITgcm/run
 cp ../../namelists_t1w1_surf/* .
 ln -sf /nobackup/dmenemen/tarballs/NA_2160/input/* .
 ln -sf /nobackup/hzhang1/forcing/jra55 .
 mpiexec -n 118 ../build/mitgcmuv
