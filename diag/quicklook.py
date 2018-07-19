import sys 
import os
sys.path.append(os.path.abspath('/home/joernc/MITgcm/utils/python/MITgcmutils/MITgcmutils'))
from mds import rdmds
import numpy as np
import matplotlib.pyplot as plt

# number of grid points
nx = 1080
ny = 540

# tile size
tilesize = 90

# time step to be analyzed
timestep = 140490

# diag level
level = 20

# tiles per row/column
tpx = nx/tilesize
tpy = ny/tilesize

def rearrange(a):
    a1 = np.reshape(a[:nx,:], (ny,nx))
    a5 = np.reshape(a[nx:,:], (nx,ny))
    a = np.concatenate((a5[:,::-1].T, a1), axis=1)
    return a, a1, a5

def rearrangeuv(U, V):
    U1 = np.reshape(U[:nx,:], (ny,nx))
    V1 = np.reshape(V[:nx,:], (ny,nx))
    U5 = np.reshape(V[nx:,:], (nx,ny))
    V5 = np.roll(np.reshape(-U[nx:,:], (nx,ny)), -1, axis=1)
    U = np.concatenate((U5[:,::-1].T, U1), axis=1)
    V = np.concatenate((V5[:,::-1].T, V1), axis=1)
    return U, V, U1, U5, V1, V5

rundir = '/nobackup1/joernc/patches/NA_2160/run_t1w1/'
diagdir = rundir + 'diags/'

# bathymetry
d = rdmds(rundir + 'Depth')
d[d==0] = np.nan
d, d1, d5 = rearrange(d)

# T, S
T = rdmds(diagdir + 'state_3d_set1', timestep, lev=level, rec=0)
S = rdmds(diagdir + 'state_3d_set1', timestep, lev=level, rec=1)
T[T==0] = np.nan
S[S==0] = np.nan
T, T1, T5 = rearrange(T)
S, S1, S5 = rearrange(S)

# U, V
U = rdmds(diagdir + 'trsp_3d_set1', timestep, lev=level, rec=0)
V = rdmds(diagdir + 'trsp_3d_set1', timestep, lev=level, rec=1)
U[U==0] = np.nan
V[V==0] = np.nan
U, V, U1, U5, V1, V5 = rearrangeuv(U, V)
Uc = (U + np.roll(U, -1, axis=1))/2
Vc = (V + np.roll(V, -1, axis=0))/2

# U, V
W = rdmds(diagdir + 'trsp_3d_set1', timestep, lev=level, rec=2)
W[W==0] = np.nan
W, _, _ = rearrange(W)

# SSH
h = rdmds(diagdir + 'state_2d_set1', timestep, rec=0)
h[h==0] = np.nan
h, h1, h5 = rearrange(h)

plt.figure()
plt.imshow(d, origin='lower')
plt.title('depth')

plt.figure()
plt.imshow(d1, origin='lower')
for x in np.arange(0, nx, tilesize):
    plt.axvline(x-.5, color='black', lw=1)
for y in np.arange(0, ny, tilesize):
    plt.axhline(y-.5, color='black', lw=1)
for i in range(tpx*tpy):
    plt.text((i%tpx+.5)*tilesize+.5, (i/tpx+.5)*tilesize+.5, i+1, ha='center',
            va='center')

plt.figure()
plt.imshow(d5, origin='lower')
for x in np.arange(0, ny, tilesize):
    plt.axvline(x-.5, color='black', lw=1)
for y in np.arange(0, nx, tilesize):
    plt.axhline(y-.5, color='black', lw=1)
for i in range(tpx*tpy):
    plt.text((i%tpy+.5)*tilesize+.5, (i/tpy+.5)*tilesize+.5, i+tpx*tpy+1,
            ha='center', va='center')

plt.figure()
plt.imshow(U, origin='lower')
plt.title('zonal velocity')

plt.figure()
plt.imshow(V, origin='lower')
plt.title('meridional velocity')

plt.figure()
plt.imshow(W, origin='lower')
plt.title('vertical velocity')
plt.colorbar()

plt.figure()
plt.imshow(np.log10((Uc**2+Vc**2)/2), origin='lower')
plt.clim(-3, .5)
plt.title('kinetic energy')

plt.figure()
plt.imshow(T, origin='lower')
plt.title('temperature')

plt.figure()
plt.imshow(S, origin='lower')
plt.title('salinity')

plt.figure()
plt.imshow(h, origin='lower')
plt.title('sea surface height')

plt.show()
