#!/bin/bash
#
#SBATCH --partition sched_mit_raffaele
##SBATCH --partition newnodes
#SBATCH --nodes 1
#SBATCH --ntasks 1
###SBATCH --mem-per-cpu 40000
##SBATCH --exclusive
#SBATCH --time 12:00:00
#SBATCH --error stderr
#SBATCH --output stdout
#SBATCH --job-name ssh
##SBATCH --mail-type "END, FAIL"
#SBATCH --mail-user joernc@mit.edu

module load engaging/python

cd /home/joernc/patches/NA_2160/diag/
python extract_ssh.py $1
