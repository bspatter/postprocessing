#!/usr/bin/env python
#
# Run a bunch of gmsh post-processors on a set of problems
# 
__author__ = 'marchdf, Edited by Brandon Patterson'
def usage():
    print '\nUsage: {0:s} [options ...]\nOptions:\n -h, --help\tshow this message and exit\n'.format(sys.argv[0])


#
# Imports
#
import sys,getopt,os,time,shutil
from numpy import *
from subprocess import call
import subprocess as sp
import time

#
# Functions
#
def write_submit(WORKDIR,SUBMIT,CMD):
    submitname = WORKDIR+'/pp_submit.batch'
    with open(submitname, "w") as f:
        f.write('#!/bin/bash\n\n')
        f.write('# Taken from https://www.tacc.utexas.edu/user-services/user-guides/stampede-user-guidef.write#running\n\n')
        f.write('#SBATCH -J '+SUBMIT[0]+'         # job name\n')
        f.write('#SBATCH -o '+SUBMIT[0]+'.o%j     # output and error file name (%j expands to jobID)\n')
        f.write('#SBATCH -p '+SUBMIT[2]+'\n')
        f.write('#SBATCH '+SUBMIT[3]+'\n')
        f.write('#SBATCH -A TG-CTS130005\n')
        f.write('#SBATCH -t '+SUBMIT[1]+'       # run time\n')
        f.write('#SBATCH --mail-user=awesome@umich.edu\n')
        f.write('#SBATCH --mail-type=begin  # email me when the job starts\n')
        f.write('#SBATCH --mail-type=end    # email me when the job finishes\n\n')
        f.write('#  Put your job commands after this line\n')
        f.write(CMD+'\n')
    return submitname


def replace_in_file(fname,replacements):
    # Replace using a dictionary of replacements (={old_string:new_string} in a file
    lines = []
    with open(fname) as fin:
        for line in fin:
            for old_string, new_string in replacements.iteritems():
                line = line.replace(old_string, new_string)
            lines.append(line)
    with open(fname, 'w') as fout:
        for line in lines:
            fout.write(line)


#
# Parse arguments
#
try:
    myopts, args = getopt.getopt(sys.argv[1:],"h",["help"])
except getopt.GetoptError as e:
    print (str(e))
    usage()
    sys.exit(2)

for o, a in myopts:
    if o in ('-h', '--help'):
        usage()
        sys.exit()


# Directories to post-process
ppdirs = ['rmawave_0_1000000.0_0.03_5.0_0.0_1.0_1.0_250_100']
#ppdirs = ['rmawave_0_1000000.0_0.03_5.0_0.0_1.0_1.0_100_100']
NUM_PROCS = '6'


# directories containing the postprocessing files
ppfdir = 'rmawave/'
#ppfiles = ['get_interface.geo','circ_enst.geo','interface_edgemid.geo','interface_minmax.geo']
ppfiles = ['circ_enst.geo','get_interface.geo']


#
# Default directories
#
BASEDIR=os.getcwd()
DATADIR=os.environ['SCRATCH']+'/'

#
# Define the resources to use
#
RUNTIME="01:30:00"
NP = 1
QUEUE="development"#"gpudev"#"development"
RESOURCES='-n '+str(NP)

#
# Commands that we will need
#
GMSH = '/home1/03773/bspatter/gmsh-2.10/bin/gmsh - '

# counters
num2submit = len(ppdirs)
cnt = 1
print 'Total number of post-processing jobs to be submitted = {0:.0f}'.format(num2submit)


for k,ppdir in enumerate(ppdirs):

    print '\nSubmitting post-processing job [{0:.0f}/{1:.0f}]'.format(cnt,num2submit); cnt += 1;

    JOBNAME = 'PP_'+ppdir.replace('/','_')
    SUBMIT=[JOBNAME,RUNTIME,QUEUE,RESOURCES]

    # Go to the work directory
    WORKDIR = DATADIR+ppdir
    os.chdir(WORKDIR)
    print 'Entering', WORKDIR

    # initialize
    CMD = ''

    # loop on post-processing files
    for ppfile in ppfiles:
        
        # create command to run
        CMD += GMSH+ppfile+';\n'

        # copy the post-proc file into our directory
        try:
            shutil.copyfile(BASEDIR+'/'+ppfdir+ppfile, ppfile)
        except IOError, e:
            print "Unable to copy pp file. %s" % e
            sys.exit()

        # replace the number of processors that were used for the run
        replace_in_file(ppfile,{'NUM_PROCS':NUM_PROCS})

        
    # write the submit file in our directory
    submitname = write_submit(WORKDIR,SUBMIT,CMD);

    # submit the run to the queue
    call('sbatch pp_submit.batch', shell=True)

    # go back to base directory
    os.chdir(BASEDIR)


    
