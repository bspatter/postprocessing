#!/usr/bin/env python
#
__author__ = 'Brandon Patterson'
def usage():
    print '\nUsage: {0:s} [options ...]\nOptions:\n -f, --force\tforce recompile\n -h, --help\tshow this message and exit\n'.format(sys.argv[0]) 


#
# Imports
#
import numpy, scipy.io, os
#
# Directories
#

# Open the daiy chain input file
valname='y0'
myfile=valname+'_field'
fname = myfile+'.pos'
fnametmp = myfile+'.tmp'
fnamemat = myfile+'.mat'

with open (fnametmp,'w') as ft:
    with open (fname,'r') as f:
        #Skip header line
        header1=f.readline();
        for line in f:
            line=line.replace('SQ(','')
            line=line.replace('SL(','')
            line=line.replace(',',' ')
            line=line.replace('){',' ')
            line=line.replace('};','')

            line = line.split();
            xtmp=[float(i) for i in line[0:12:3]] #x tmp
            x=sum(xtmp)/4
            ytmp=[float(i) for i in line[1:12:3]] #y tmp
            y=sum(ytmp)/4
#            ztmp=[float(i) for i in line[2:12:3]] #z tmp #Grabs z value, but for 2D, this is always zero, so we comment
#            z=sum(ztmp)/4
            vtmp=[float(i) for i in line[12:16:1]] #value tmp
            v=sum(vtmp)/4
            

            ft.write("%02.14f %02.14f %02.12f %02.14f\n" % (x,y, z, v))
        
# Reload temporary data file as numpy array for writing to .mat
data = numpy.loadtxt(fnametmp,skiprows=0)
data = data[0:-1, :] #Remove blank line at the end



#Write x,y and v data to matlab file
scipy.io.savemat(fnamemat, appendmat=True, format='5', long_field_names=False, do_compression=False, oned_as='column', mdict={'x':data[:,0], 'y':data[:,1], valname:data[:,3]})
