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
start = 17830
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
if not os.path.isdir(savedir + "eke_map/"):
    os.mkdir(savedir + "eke_map/")

# save coordinates to file
np.savez(savedir+"eke_map/coord.npz", x=XC, y=YC)

# initialize arrays holding 24 hours of data (for daily averages)
U_24 = np.zeros((24,540,2160))
V_24 = np.zeros((24,540,2160))

# loop over hours
for hour in range(start, end+1):

    # do not redo calculation if not needed (24 hours into future)
    file_list = [savedir + "eke_map/rec_{0:010d}.npy".format(hour+j)
            for j in range(24)]
    file_exists = [os.path.isfile(file_list[j]) for j in range(24)]

    # if this step is required
    if force_overwrite or not all(file_exists):

        # location in 24-hour arrays
        i = hour%24

        # get time step
        step = hour*3600/dt

        print hour, step, i

        # read velocities
        U = rdmds(diagdir + 'trsp_3d_set1', step, rec=0, lev=level)
        V = rdmds(diagdir + 'trsp_3d_set1', step, rec=1, lev=level)
        U, V = utils.rearrange_velocities(U, V)

        # save into 24-hour arrays
        U_24[i,:,:] = U
        V_24[i,:,:] = V

        # if daily average is required (not just required for future time)
        if force_overwrite or not file_exists[0]:

            # daily averages
            U_avg = np.mean(U_24, axis=0)
            V_avg = np.mean(V_24, axis=0)

            # kinetic energy (from daily average)
            U_avg_c = (U_avg + np.roll(U_avg, -1, axis=1))/2
            V_avg_c = (V_avg + np.roll(V_avg, -1, axis=0))/2
            eke = (U_avg_c**2 + V_avg_c**2)/2

            # save daily average KE
            np.save(savedir + 'eke_map/rec_{0:010d}.npy'.format(hour), eke)
