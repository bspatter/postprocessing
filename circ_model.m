fid=fopen('circ.dat')
fspec='%s';
N=250;
header=textscan(fid,fspec,N)
fspec='%n %f'
data=textscan(fid,fspec,N)
fclose(fid)
