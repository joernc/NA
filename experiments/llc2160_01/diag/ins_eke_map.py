import sys 
import os
sys.path.append(os.path.abspath("/home/joernc/MITgcm/utils/python/MITgcmutils/MITgcmutils"))
from mds import rdmds
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm
import utils

# experiment name
name = sys.argv[1]

# steps (in hours)
start = 17860
end = 17860

# time step
dt = 240

# model level
level = 0

# force overwriting existing diag files?
force_overwrite = False

# base dir with experiment data
basedir = '/nobackup1/joernc/patches/NA_2160/'

# run dir
rundir = basedir + 'run_' + name + '/'

# subdir with diagnostics
diagdir = rundir + 'diags/'

# location where diag files are saved
savedir = basedir + "diag/" + name + "/"

# get grid info
XC, YC, XG, YG = utils.get_x_y(rundir)
DXC, DYC, DXG, DYG = utils.get_dx_dy(rundir)

# create output dir if it doesn't exist yet
if not os.path.isdir(savedir):
    os.mkdir(savedir)
if not os.path.isdir(savedir + "ins_eke_map/"):
    os.mkdir(savedir + "ins_eke_map/")

# save coordinates to file
np.savez(savedir+"eke_map/coord.npz", x=XC, y=YC)

# loop over hours
for hour in range(start, end+1):

    # if this step is required
    if not os.path.isfile(savedir + 'ins_eke_map/rec_{0:010d}.npy'.format(hour)) or force_overwrite:

        # get time step
        step = hour*3600/dt

        print hour, step

        # read velocities
        U = rdmds(diagdir + 'trsp_3d_set1', step, rec=0, lev=level)
        V = rdmds(diagdir + 'trsp_3d_set1', step, rec=1, lev=level)
        U, V = utils.rearrange_velocities(U, V)

        eke = (U**2 + V**2)/2

        # save KE
        np.save(savedir + 'ins_eke_map/rec_{0:010d}.npy'.format(hour), eke)
