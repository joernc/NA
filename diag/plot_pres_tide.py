import numpy as np
import matplotlib.pyplot as plt

days = 365
p = np.memmap("/nobackup1/joernc/patches/jra55/jra55_pres_tide_2013",
        dtype=np.dtype(">f"), mode="r", shape=(days*24,320,640))

plt.figure()
plt.imshow(p[-1,:,:], origin="lower")
plt.show()
