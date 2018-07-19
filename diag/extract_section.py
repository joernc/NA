import sys 
import os
sys.path.append(os.path.abspath("/home/joernc/MITgcm/utils/python/MITgcmutils/MITgcmutils"))
from mds import rdmds
import numpy as np
import numpy.ma as ma
import utils

# section location
lon = -67.

# experiment name
name = sys.argv[1]

# steps (in hours)
start = 1
end = 20000

# time step
dt = 240

# force overwriting existing diag files?
force_overwrite = False

# base dir with experiment data
basedir = '/nobackup1/joernc/patches/NA_2160/'

# run dir
rundir = basedir + 'run_' + name + '/'

# subdir with diagnostics
diagdir = rundir + 'diags/'

# location where diag files are saved
savedir = basedir + 'diag/' + name + '/section_{:04d}/'.format(int(lon))

# create output dir if it doesn't exist yet
if not os.path.isdir(savedir):
    os.mkdir(savedir)

# get grid info
XC, YC, XG, YG = utils.get_x_y(rundir)
z = rdmds(rundir + "RC")[:,0,0]
z = z[utils.diag_lev]

# find index of nearest model point in rotated orientation

dist = (XC[0,:]-lon)**2
dist[np.isnan(dist)] = 999.
ix = np.argmin(dist)

# make sure correct location was chosen
print XC[0,ix]

# loop over hours
for hour in range(start,end+1):

    # file to save record to
    savefile = savedir + "rec_{:010d}.npz".format(hour)

    # if this step is required
    if (not os.path.isfile(savefile)) or force_overwrite:

        # get time step and file location

        step = hour*3600/dt
        print hour, step

        # read variables
        T = rdmds(diagdir + 'state_3d_set1', step, rec=0)
        S = rdmds(diagdir + 'state_3d_set1', step, rec=1)
        T = utils.rearrange3d(T)
        S = utils.rearrange3d(S)

        # save to file
        np.savez(savefile, z=z, y=YC[:,ix], T=T[:,:,ix], S=S[:,:,ix])
