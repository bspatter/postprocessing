#!/usr/bin/env python
#
# Using the .txt files, get the mass fraction contours
# 
#
__author__ = 'marchdf, modified by brandon patterson'

#================================================================================
#
# Imports
#
#================================================================================
import sys, os
import numpy as np
import read2dpos_nodal as r2d
import scipy.io
from scipy.integrate import simps
from scipy.interpolate import interp1d

from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt


#================================================================================
#
# Functions
#
#================================================================================


#================================================================================
#
# Setup
#
#================================================================================
fnames = [filename for filename in os.listdir('.') if filename.startswith("y0") and filename.endswith(".txt")]
timesteps = range(len(fnames))



#================================================================================
#
# Initialize
#
#================================================================================
valname='y0_050'
myfile=valname+'_contours'
fnamemat = myfile+'.mat'

t = np.zeros(len(timesteps))
y0 = np.zeros(len(timesteps))

x0=np.arange(0.005,0.995,0.005) # Values to interpolate along

# initialize figure
plt.figure()


#================================================================================
#
# Loop on time steps
#
#================================================================================

for k,timestep in enumerate(timesteps): 

    # fields to load
    y0name = 'y0{0:010d}.txt'.format(timestep)

    # Load the data
    timestep,time,y0_df = r2d.read2dpos_nodal_qua(y0name)

    # Get centroid data
    Y0 = r2d.df_qua_cellcenter(y0_df)

    # Get a numpy meshgrid of the centroid data
    x,y,y0 = r2d.df_qua_cellcenter_to_numpy(y0_df)

    # Make pcolormesh plot
    plt.pcolormesh(x,y,y0)
    
    # Modify plot details
    plt.axis('equal')
    ax=plt.gca();
    ax.set_xlim([0,1])
    ax.set_ylim([-1,1])

    # Get the contours
    levels=np.array([0.5])
    cs1=plt.contour(x,y,y0,levels,colors='k',linewidths=3)
    p = cs1.collections[0].get_paths()[0] 
    v = p.vertices
    cx=v[:,0]
    cy=v[:,1]

    if k==0:
        # xdata=np.zeros((len(timesteps),len(cx)))
        # ydata=np.zeros((len(timesteps),len(cy)))
        ydata=np.zeros((len(timesteps),len(x0)))

    # xdata[k,:]=cx
    # ydata[k,:]=cy

    ydata[k,:] = np.interp(x0,cx,cy)

    print "step "+str(k)+"/"+str(len(timesteps)-1)
    
#    print np.interp(x0,cx,cy)
#    plt.show()




#Write x,y and v data to matlab file
scipy.io.savemat(fnamemat, appendmat=True, format='5', long_field_names=False, do_compression=False, oned_as='column', mdict={'x':x0, 'y':ydata,})


    
#================================================================================
#
# Save data to a file 
#
#================================================================================
# oname = './interface/y0.dat'
# np.savetxt(oname, np.vstack([t,
#                              y0,
#            delimiter=',',
#            header='time, y0')
