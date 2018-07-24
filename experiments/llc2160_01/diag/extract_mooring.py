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

# mooring location
if sys.argv[2] == '0':
    lon = -60.33
    lat = 39.479
elif sys.argv[2] == '1':
    lon = -44.11
    lat = 38.973
elif sys.argv[2] == '2':
    lon = -21.996
    lat = 33.001

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
        + "/mooring_{:04d}_{:04d}/".format(int(lon),int(lat))

# create output dir if it doesn't exist yet
if not os.path.isdir(savedir):
    os.mkdir(savedir)

# get grid info
XC, YC, XG, YG = utils.get_x_y(rundir, do_rearrange=False)
z = rdmds(rundir + "RC")[:,0,0]

# save diag depths to file
np.save(savedir + "depths.npy", z[utils.diag_lev])

# find index of nearest model point (c, fx, fy) in original orientation

dist = (XC-lon)**2+(YC-lat)**2
dist[np.isnan(dist)] = 999
iyc, ixc = np.unravel_index(np.argmin(dist), dist.shape)

dist = (XG-lon)**2+(YC-lat)**2
dist[np.isnan(dist)] = 999
iyfx, ixfx = np.unravel_index(np.argmin(dist), dist.shape)

dist = (XC-lon)**2+(YG-lat)**2
dist[np.isnan(dist)] = 999
iyfy, ixfy = np.unravel_index(np.argmin(dist), dist.shape)

# make sure we're reading the correct location
XC = rdmds(rundir + "XC", region=(ixc,ixc+1,iyc,iyc+1))
YC = rdmds(rundir + "YC", region=(ixc,ixc+1,iyc,iyc+1))
print ixc, iyc
print XC, YC

# loop over hours
for hour in range(start, end+1):

    # file to save record to
    savefile = savedir + "rec_{:010d}.npz".format(hour)

    # if this step is required
    if (not os.path.isfile(savefile)) or force_overwrite:

        step = hour*3600/dt
        print hour, step

        # read variables
        U = rdmds(diagdir + 'trsp_3d_set1', step, rec=0,
                region=(ixfx,ixfx+1,iyfx,iyfx+1))[:,0,0]
        V = rdmds(diagdir + 'trsp_3d_set1', step, rec=1,
                region=(ixfy,ixfy+1,iyfy,iyfy+1))[:,0,0]
        try:
            W = rdmds(diagdir + 'trsp_3d_set1', step, rec=2,
                    region=(ixc,ixc+1,iyc,iyc+1))[:,0,0]
        except ValueError:
            print 'No vertical velocity!'
            W = np.nan
        T = rdmds(diagdir + 'state_3d_set1', step, rec=0,
                region=(ixc,ixc+1,iyc,iyc+1))[:,0,0]
        S = rdmds(diagdir + 'state_3d_set1', step, rec=1,
                region=(ixc,ixc+1,iyc,iyc+1))[:,0,0]
        h = rdmds(diagdir + 'state_2d_set1', step, rec=0,
                region=(ixc,ixc+1,iyc,iyc+1))[0,0]

        # save to file
        np.savez(savefile, u=U, v=V, w=W, T=T, S=S, h=h)
