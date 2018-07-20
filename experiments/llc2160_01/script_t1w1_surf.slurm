#!/bin/bash
#
#SBATCH --partition sched_mit_raffaele
##SBATCH --partition newnodes
##SBATCH --partition sched_mit_hill
#SBATCH --nodes 6
##SBATCH --nodes 8
##SBATCH --exclude node[339-342]#,node[424-425]
##SBATCH --exclude node[021-022]
#SBATCH --ntasks 118
#SBATCH --exclusive
#SBATCH --mem 64000
#SBATCH --time 24:00:00
##SBATCH --time 12:00:00
#SBATCH --error stderr_t1w1_surf
#SBATCH --output stdout_t1w1_surf
#SBATCH --job-name t1w1_surf
#SBATCH --mail-type FAIL,END
#SBATCH --mail-user joernc@mit.edu

#--- 0.load modules ------
module purge
module add engaging/intel/2013.1.046
module add netcdf netcdff
module add slurm

ulimit -s unlimited

#---- 1.set variables ------
#note for bash: can not have any space around =

nprocs=118

expname=t1w1_surf

#--- 2.set dir ------------
basedir=/home/joernc/patches/NA_2160
scratchdir=/nobackup1/joernc/patches/NA_2160

codedir=$basedir/code
builddir=$basedir/build

workdir=$scratchdir/run_$expname
inputdir=$basedir/namelists_$expname

if [ ! -d $workdir ]; then
  mkdir -p $workdir;
  mkdir -p $workdir/diags;
fi
cd $workdir;

cp -rf ${codedir}/ .

#--- 3. link forcing -------------
if [ ! -h jra55 ]; then
  ln -sf /nobackup1/joernc/patches/jra55 ./jra55
fi

#--- 4. linking binary ---------
ln -sf ${basedir}/input/*.bin .
ln -sf ${basedir}/input/tile*.mitgrid .
###

#--- 6. NAMELISTS ---------
cp -f $inputdir/* .

#--- 7. executable --------
\rm -f mitgcmuv*
cp -f $builddir/mitgcmuv ./mitgcmuv

#--- 8. pickups -----------

#--- 9. make a list of all linked files ------

#--- 11. run ----------------------------------

set -x
date > run.MITGCM.timing
mpirun -np $nprocs ./mitgcmuv
date >> run.MITGCM.timing
