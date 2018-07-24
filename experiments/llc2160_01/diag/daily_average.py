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

# number of steps (in hours)
start = 1
end = 50000

# grid
nx = 1080
ny = 540

# time step
dt = 240

# model level (surface)
level = int(sys.argv[2])

# force overwriting existing diag files?
force_overwrite = False

# base dir with experiment data
basedir = '/nobackup1/joernc/patches/NA_2160/'

# run dir
rundir = basedir + 'run_' + name + '/'

# subdir with diagnostics
diagdir = rundir + 'diags/'

# location where diag files are saved
savedir_rec = basedir + "diag/" + name + "/eke/"
savedir_fig = basedir + "diag/fig_" + name + "/"

# get grid info
DXC, DYC, DXG, DYG = utils.get_dx_dy(rundir)

# create output dirs if they don't exist yet
if not os.path.isdir(basedir + "diag/" + name):
    os.mkdir(basedir + "diag/" + name)
if not os.path.isdir(savedir_rec):
    os.mkdir(savedir_rec)
if not os.path.isdir(savedir_fig):
    os.mkdir(savedir_fig)

# initialize arrays holding 24 hours of data (for daily averages)
U_24 = np.zeros((24,ny,2*nx))
V_24 = np.zeros((24,ny,2*nx))

# loop over hours
for hour in range(start, end+1):

    # do not redo calculation if not needed (24 hours into future)
    file_list = [savedir_rec + "rec_{:03d}_{:010d}.npz".format(level, hour+j)
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
        U,V = utils.rearrange_velocities(U,V)

        # save into 24-hour arrays
        U_24[i,:,:] = U
        V_24[i,:,:] = V

        # velocities at grid centers, KE
        Uc = (U + np.roll(U, -1, axis=1))/2
        Vc = (V + np.roll(V, -1, axis=0))/2
        KE = (Uc**2 + Vc**2)/2

        # save speed snapshot
        plt.imsave(savedir_fig
                + "vel_ins_{:03d}_{:010d}.png".format(level, hour),
                np.log10(KE)[::-1,:], vmin=-4, vmax=.5, dpi=300)

        # if daily average is required (not just required for future time)
        if force_overwrite or not file_exists[0]:

            # daily averages
            U_avg = np.mean(U_24, axis=0)
            V_avg = np.mean(V_24, axis=0)

            # velocities at grid centers, KE
            U_avg_c = (U_avg + np.roll(U_avg, -1, axis=1))/2
            V_avg_c = (V_avg + np.roll(V_avg, -1, axis=0))/2
            KE_avg = (U_avg_c**2 + V_avg_c**2)/2

            # save daily average speed map
            plt.imsave(savedir_fig
                    + "vel_avg_{:03d}_{:010d}.png".format(level, hour),
                    np.log10(KE_avg)[::-1,:], vmin=-4, vmax=.5, dpi=300)

            # calculate areas
            area_u = np.sum((DXG*DYC)[np.logical_not(np.isnan(U))])
            area_v = np.sum((DXC*DYG)[np.logical_not(np.isnan(V))])

            # calculate instantaneous KE weighted by area
            KE_int = (np.nansum(U**2*DXG*DYC)/area_u
                    + np.nansum(V**2*DXC*DYG)/area_v)/2

            # calculate daily average KE weighted by area
            KE_avg_int = (np.nansum(U_avg**2*DXG*DYC)/area_u
                    + np.nansum(V_avg**2*DXC*DYG)/area_v)/2

            # save KE to file
            np.savez(savedir_rec + "rec_{:03d}_{:010d}.npz".format(level, hour),
                    KE=KE_int, KE_avg=KE_avg_int)
