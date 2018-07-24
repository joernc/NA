import sys 
import os
sys.path.append(os.path.abspath("/home/joernc/MITgcm/utils/python/MITgcmutils/MITgcmutils"))
from mds import rdmds
import numpy as np

nx = 1080
ny = 540
nz = 55 # diag levels

# model levels with diagnostics (data.diagnostics, converted to 0-based index)
diag_lev = np.array([1,2,3,4,5,6,7,8,9,10,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99])-1

def rearrange(a):
    a1 = np.reshape(a[:nx,:], (ny,nx))
    a5 = np.reshape(a[nx:,:], (nx,ny))
    a = np.concatenate((a5[:,::-1].T, a1), axis=1)
    a[a==0.] = np.nan
    return a

def rearrange3d(a):
    a1 = np.reshape(a[:,:nx,:], (nz,ny,nx))
    a5 = np.reshape(a[:,nx:,:], (nz,nx,ny))
    a = np.concatenate((np.swapaxes(a5[:,:,::-1], 1, 2), a1), axis=2)
    a[a==0.] = np.nan
    return a

def rearrange_grid_spacing(dx, dy):
    dx1 = np.reshape(dx[:nx,:], (ny,nx))
    dy1 = np.reshape(dy[:nx,:], (ny,nx))
    dx5 = np.reshape(dy[nx:,:], (nx,ny))
    dy5 = np.reshape(dx[nx:,:], (nx,ny))
    dx = np.concatenate((dx5[:,::-1].T, dx1), axis=1)
    dy = np.concatenate((dy5[:,::-1].T, dy1), axis=1)
    dx[dx==0.] = np.nan
    dy[dy==0.] = np.nan
    return dx, dy

def rearrange_velocities(u, v):
    u1 = np.reshape(u[:nx,:], (ny,nx))
    v1 = np.reshape(v[:nx,:], (ny,nx))
    u5 = np.reshape(v[nx:,:], (nx,ny))
    v5 = np.roll(np.reshape(-u[nx:,:], (nx,ny)), -1, axis=1)
    u = np.concatenate((u5[:,::-1].T, u1), axis=1)
    v = np.concatenate((v5[:,::-1].T, v1), axis=1)
    u[u==0.] = np.nan
    v[v==0.] = np.nan
    return u,v

def get_x_y(folder, do_rearrange=True):
    XC = rdmds(folder+"XC")
    XG = rdmds(folder+"XG")
    YC = rdmds(folder+"YC")
    YG = rdmds(folder+"YG")
    if do_rearrange:
        XC = rearrange(XC)
        XG = rearrange(XG)
        YC = rearrange(YC)
        YG = rearrange(YG)
    return XC, YC, XG, YG

def get_dx_dy(folder):
    DXC = rdmds(folder+"DXC")
    DYC = rdmds(folder+"DYC")
    DXG = rdmds(folder+"DXG")
    DYG = rdmds(folder+"DYG")
    DXC, DYC = rearrange_grid_spacing(DXC, DYC)
    DXG, DYG = rearrange_grid_spacing(DXG, DYG)
    return DXC, DYC, DXG, DYG
