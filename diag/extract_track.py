import sys 
import os
sys.path.append(os.path.abspath("/home/joernc/MITgcm/utils/python/MITgcmutils/MITgcmutils"))
from mds import rdmds
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm
import datetime as dt
import utils

# experiment name
name = sys.argv[1]

# track location
if sys.argv[2] == '0':
    lon = -68.
    lat0 = 32.
    lat1 = 37.
elif sys.argv[2] == '1':
    lon = -30.
    lat0 = 32.
    lat1 = 37.
elif sys.argv[2] == '2':
    lon = -68.
    lat0 = 30.
    lat1 = 35.
elif sys.argv[2] == '3':
    lon = -30.
    lat0 = 30.
    lat1 = 35.

# steps (in hours)
start = 1
end = 50000

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
savedir = basedir + "diag/" + name \
        + "/track_{:04d}_{:04d}_{:04d}/".format(int(lon), int(lat0), int(lat1))

# create output dir if it doesn't exist yet
if start == 1 and not os.path.isdir(savedir):
    os.mkdir(savedir)

# get grid info
XC, YC, XG, YG = utils.get_x_y(rundir)
DXC, DYC, DXG, DYG = utils.get_dx_dy(rundir)

# find index of nearest model point (c, fx, fy) in rotated orientation

dist = (XC-lon)**2+(YC-lat0)**2
dist[np.isnan(dist)] = 999
iy0c, ixc = np.unravel_index(np.argmin(dist), dist.shape)

dist = (XC-lon)**2+(YC-lat1)**2
dist[np.isnan(dist)] = 999
iy1c, ixc = np.unravel_index(np.argmin(dist), dist.shape)

# make sure correct location was chosen
print XC[iy0c:iy1c+1,ixc]
print YC[iy0c:iy1c+1,ixc]

# loop over hours
for hour in range(start, end+1):

    # file to save record to
    savefile = savedir + "rec_{:010d}.npy".format(hour)

    # if this step is required
    if (not os.path.isfile(savefile)) or force_overwrite:

        step = hour*3600/dt
        print hour, step

        # read variable
        h = rdmds(diagdir + 'state_2d_set1', step, rec=0)
        h = utils.rearrange(h)

        # save to file
        np.save(savefile, h[iy0c:iy1c+1,ixc])
