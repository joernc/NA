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
import scipy.io as sio

# experiment name
name = sys.argv[1]

# steps (in hours)
start = 17860-24
end = 17860

# grid
nx = 1080
ny = 540

# time step
dt = 240

# force overwriting existing diag files?
force_overwrite = True

# base dir with experiment data
basedir = '/nobackup1/joernc/patches/NA_2160/'

# run dir
rundir = basedir + 'run_' + name + '/'

# subdir with diagnostics
diagdir = rundir + 'diags/'

# location where diag files are saved
savedir = basedir + "diag/" + name + "/ssh/"

# create output dir if it doesn't exist yet
if not os.path.isdir(basedir + "diag/" + name):
    os.mkdir(basedir + "diag/" + name)
if not os.path.isdir(savedir):
    os.mkdir(savedir)

# get grid info
XC, YC, XG, YG = utils.get_x_y(rundir)
DXC, DYC, DXG, DYG = utils.get_dx_dy(rundir)

# hold 1 day
h24 = np.empty((24, ny, 2*nx))

# loop over hours
for hour in range(start, end+1):

    step = hour*3600/dt
    print hour, step

    # read variables
    h = rdmds(diagdir + 'state_2d_set1', step, rec=0)
    h = utils.rearrange(h)
    U = rdmds(diagdir + 'trsp_3d_set1', step, rec=0, lev=0)
    V = rdmds(diagdir + 'trsp_3d_set1', step, rec=1, lev=0)
    U,V = utils.rearrange_velocities(U,V)

    # compute KE
    U_c = (U + np.roll(U, -1, axis=1))/2
    V_c = (V + np.roll(V, -1, axis=0))/2
    KE = (U_c**2 + V_c**2)/2

    # collect 24 hourly SSH fields
    h24[hour%24,:,:] = h

# daily average
hd = np.mean(h24, axis=0)

sio.savemat("ssh.mat", {"h": h, "hd": hd, "ke": KE, "x": XC, "y": YC})
