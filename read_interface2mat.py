#!/usr/bin/env python
#
__author__ = 'Brandon Patterson'
def usage():
    print '\nUsage: {0:s} [options ...]\nOptions:\n -f, --force\tforce recompile\n -h, --help\tshow this message and exit\n'.format(sys.argv[0]) 


#
# Imports
#
import numpy, scipy.io, os
import read_isosurface_pos as rip

# Define output file
infilestr='interface';
outfile='interface_location.mat';

# step parameters 
t0 = 0;
tfinal=250;


# initialize data
xm=[];
ym=[];


for t in range(t0,tfinal+1):
    filename=infilestr+"{0:03.0f}".format(t)+".pos";
    #print filename+"\n"
    x,y = rip.read_isosurface_pos(filename)

    y = [j for (i,j) in sorted(zip(x,y), key=lambda pair: pair[0])]
    x = sorted(x)

    xm.extend(x)
    ym.extend(y)

scipy.io.savemat(outfile, appendmat=True, format='5', long_field_names=False, do_compression=False, oned_as='column', mdict={'x':xm[:], 'y':ym[:]})


print "\nx,y location of interface written to "+outfile+" for steps "+str(t0)+"-"+str(tfinal)+"\n."


