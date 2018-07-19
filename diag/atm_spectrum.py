import numpy as np
import matplotlib.pyplot as plt
import calendar
import mtspec as mt

path = '/nobackup1/joernc/patches/jra55/'

year = 2013

# SPURS
lon_mooring = -38.
lat_mooring = 25.

# load JRA grid
f = np.load("jra55_grid.npz")
lat = f["lat"]
lon = f["lon"]

# find closest point to mooring
idx = np.argmin(np.abs(np.mod(lon-lon_mooring,360)**2+(lat-lat_mooring)**2))
ilat, ilon = np.unravel_index(idx, (320,640))
print lon[:,ilon], lat[ilat,:]

days = 366 if calendar.isleap(year) else 365
uvel = np.memmap("{:s}jra55_u10m_{:4d}".format(path, year),
            dtype=np.dtype(">f"), mode="r", shape=(days*24/3,320,640))
vvel = np.memmap("{:s}jra55_v10m_{:4d}".format(path, year),
            dtype=np.dtype(">f"), mode="r", shape=(days*24/3,320,640))

np.savez('spurs.npz', uvel=uvel[:,ilat,ilon], vvel=vvel[:,ilat,ilon])

spec_u, freq_u, jack_u, _, _ = mt.mtspec(data=uvel[:,ilat,ilon], delta=3*3600.,
                time_bandwidth=8, statistics=True)
spec_v, freq_v, jack_v, _, _ = mt.mtspec(data=vvel[:,ilat,ilon], delta=3*3600.,
                time_bandwidth=8, statistics=True)

plt.figure()
plt.pcolor(lon, lat, uvel[0,:,:])

plt.figure()
plt.plot(uvel[:,ilat,ilon], color='tab:blue')
plt.plot(vvel[:,ilat,ilon], color='tab:orange')

plt.figure()
plt.loglog(freq_u, 1e-6*freq_u**-2, color='gray')
plt.loglog(freq_u, 1e-10*freq_u**-3, color='gray')
plt.fill_between(freq_u, jack_u[:,0], jack_u[:,1], alpha=.3, linewidth=0,
        color='tab:blue')
plt.fill_between(freq_v, jack_v[:,0], jack_v[:,1], alpha=.3, linewidth=0,
        color='tab:orange')
plt.loglog(freq_u, spec_u, color='tab:blue')
plt.loglog(freq_v, spec_v, color='tab:orange')

plt.show()
