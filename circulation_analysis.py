#!/usr/bin/env python
#
# Plot the initial condition of an interface with that exponential function
# Also do other things like calculate density gradients
# Using brandon's ramp wave, try to predict the circulation as well.
#
# See notes on this topic: 01/01/2016
#
#
__author__ = 'marchdf'

#================================================================================
#
# Imports
#
#================================================================================
# Ignore deprecation warnings
import numpy as np
import matplotlib.axis as axis
from pylab import *

#================================================================================
#
# Some defaults variables
#
#================================================================================
plt.rc('text', usetex=True)
plt.rc('font', family='serif', serif='Times')
cmap_med =['#F15A60','#7AC36A','#5A9BD4','#FAA75B','#9E67AB','#CE7058','#D77FB4','#737373']
cmap =['#EE2E2F','#008C48','#185AA9','#F47D23','#662C91','#A21D21','#B43894','#010202']
dashseq = [(None,None),[10,5],[10, 4, 3, 4],[3, 3],[10, 4, 3, 4, 3, 4],[3, 3],[3, 3]];
markertype = ['s','d','o','p','h']



#================================================================================
#
# Basic information/setup
#
#================================================================================

# material parameters
p0 = 101325            # background pressure
gamma_air = 1.4
rho_air = 1.1765
cs_air = sqrt(gamma_air*p0/rho_air)
rho_water = 996
gamma_water = 5.5
pinf_water = 492115000
cs_water = sqrt(gamma_water*(p0+pinf_water)/rho_water)

# interface parameters
rho1 = rho_water       # density of the top fluid
rho2 = rho_air         # density of the bottom fluid
delta = 0.08           # thickness of the interface
y0 = 0                 # original y location of the interface
a0 = 0.03              # interface amplitude

# wave parameters
pa = 1               # pressure amplitude of the ramp
w  = 5                 # width of the ramp wave
dt = w/cs_water        # interaction time of the wave and interface
w_air = dt*cs_air      # width of the wave in the air

# ND parameters
t_ND   = 1/cs_air
rho_ND = rho_air
u_ND   = cs_air
p_ND   = rho_air*(cs_air**2)

# nd everything
rho1 = rho1/rho_ND
rho2 = rho2/rho_ND
p0   = p0/p_ND
pa   = pa/p_ND
dt   = dt/t_ND
pinf_water = pinf_water/p_ND

# transmission and reflection coefficients
R = (1- rho_water*cs_water/(rho_air*cs_air))/(1+rho_water*cs_water/(rho_air*cs_air));
T = 1 + R;
#print(R,T,T*pa+p0)

# Calculate the compression due to the wave
# print('Volume compression ratio in the water a = a_0 *',((pa+p0+pinf_water)/(p0+pinf_water))**(-1.0/gamma_water))
# print('Density compression ratio in the water rho = rho_0 *',((pa+p0+pinf_water)/(p0+pinf_water))**(1.0/gamma_water))
# print('Volume compression ratio in the air a = a_0 *',((pa+p0)/p0)**(-1.0/gamma_air))
# print('Density compression ratio in the air rho = rho_0 *',((pa+p0)/p0)**(1.0/gamma_air))


# discretize
Nx = 500+1
Ny = 500+1
x = np.linspace(0,1,Nx)
y = np.linspace(-10*a0,10*a0,Ny)
xx,yy = np.meshgrid(x,y)


#================================================================================
#
# Calculate the interface smearing
#
#================================================================================

# distance function from the interface
d = 1.0/(2*delta) * (delta + a0*sin(2*pi*xx - pi/2) - yy + y0)

# volume fraction: the way this is done implies that the mixture
# region is going to take place in a tickness of 2 delta
vol = np.zeros(shape(d))
dcut = np.zeros(shape(d))
for i in range(shape(d)[0]):
    for j in range(shape(d)[1]):
        distance = d[i,j]
        if ((0 < distance) and (distance<1)):
            vol[i,j] = exp(log(10**(-16)) * (abs(distance)**8)) #distance
            dcut[i,j] = d[i,j]
        elif (distance <= 0):
            vol[i,j] = 1
            dcut[i,j] = 0
        else:
            vol[i,j] = 0
            dcut[i,j] = 0

# density in the domain based on the volume fractions
rho = (1-vol)*rho2 + vol*rho1


#================================================================================
#
# Now let's calculate some gradients
#
#================================================================================

# Get the normal vector
nx = -a0*2*pi*cos(2*pi*x-pi/2)
ny = ones(shape(x))
n  = vstack([nx,ny])
# normalize it
n  = n/norm(n,axis=0)
nx = n[0,:]
ny = n[1,:]

# angle between the normal and the horizontal
phi = np.arctan2(ny,nx)

# angle between the normal and the vertical
theta = pi/2 - phi

# transmitted angle (Snell's law)
theta_t = arcsin(cs_air/cs_water*sin(theta))

# volume fraction gradients
K = log(10**(-16)) * exp( log(10**(-16)) * (dcut**8) ) * 8*(dcut**7)
dvoldx = K * a0*pi/delta*sin(2*pi*xx)
dvoldy = K * (-1.0/(2*delta))

# density gradients
drhodx = -dvoldx*rho2 + dvoldx*rho1
drhody = -dvoldy*rho2 + dvoldy*rho1

# norm of density gradient
drho = sqrt(drhodx**2 + drhody**2)


#================================================================================
#
# Let's try to get a circulation thing going on now for Brandon's case
#
#================================================================================
dpdx = 0
dpdy = -T*pa/w_air #- R*pa/w
dp   = sqrt(dpdx**2 + dpdy**2)

# expression for the vorticity: three ways of getting the same
# answer. The fourth expression here is an approximation of the other
# two


#domegadt = drho * dp / (rho**2) * sin(theta_t)
#domegadt = drhodx*dpdy /(rho**2) ###################################### THIS WORKS
domegadt = fabs(K)/(2*delta) * abs(rho1-rho2) * dpdy / (rho**2) * sin(theta) ###################################### THIS ALSO WORKS

# Integrate vorticity in the half domain in x and full domain in y
dGdt = np.trapz(np.trapz(domegadt[:,:Nx/2],xx[:,:Nx/2]),y)
print("The predicted dG/dt in the half domain is =",dGdt)

# Integrate this over the wave interaction time
G = dt*dGdt
print("The predicted circulation in the half domain after wave interaction is = {0:f} (or {0:e}).".format(G))


#================================================================================
#
# Plots
#
#================================================================================

# interface location (actual, lower and upper)
interface = a0*sin(2*pi*x - pi/2) + y0
upper     = delta+a0*sin(2*pi*x - pi/2) + y0
lower     =-delta+a0*sin(2*pi*x - pi/2) + y0

# plot the density in the domain
figure(0)
cs  = contourf(xx,yy,rho,100,cmap=get_cmap('RdBu_r'))
cbar = colorbar(cs)
cbar.ax.set_xlabel(r'$\rho$',fontsize=22,fontweight='bold')
plot(x,interface,'k',lw=2)
plot(x,upper,'k',lw=2)
plot(x,lower,'k',lw=2)
cs = contour(xx,yy,vol,levels=[0.5,10],colors=cmap[4],linewidths=2,linestyles='--')
savefig('rho.pdf',format='pdf')

# plot a 1D slice of the volume fraction as well as the 1% and 99%
# contour levels
figure(1)
v = vol[:,Nx/4]
idx1 = argmin( abs(v - 0.05) )
idx2 = argmin( abs(v - 0.95) )
plot(y,v,color=cmap[0],lw=2)
plot([y[idx1],y[idx1]], [-0.1,1.1], color=cmap[1],lw=1)
plot([y[idx2],y[idx2]], [-0.1,1.1],color=cmap[2],lw=1)
print("The distance between the 95% and 5% volume fraction levels is {0:f} delta.".format((y[idx2]-y[idx1])/delta))
plot([y[idx1],y[idx2]], [0,1],color=cmap[2],lw=1)
xlabel(r"$y$",fontsize=22,fontweight='bold')
ylabel(r"Volume fraction",fontsize=22,fontweight='bold')

# plot the norm of the density gradient
figure(2)
cs  = contourf(xx,yy,drho,100,cmap=get_cmap('Blues'))
cbar = colorbar(cs)
plot(x,interface,'k',lw=2)
plot(x,upper,'k',lw=2)
plot(x,lower,'k',lw=2)
cbar.ax.get_yaxis().labelpad = 40
cbar.ax.set_ylabel(r'$|| \nabla \rho ||$',fontsize=22,fontweight='bold', rotation=0)
cs = contour(xx,yy,vol,levels=[0.5,10],colors=cmap[4],linewidths=2,linestyles='--')
savefig('grad_rho.pdf',format='pdf')

# plot the predicted vorticity
figure(3)
cs  = contourf(xx,yy,domegadt,100,cmap=get_cmap('RdBu_r'))
cbar = colorbar(cs)
plot(x,interface,'k',lw=2)
plot(x,upper,'k',lw=2)
plot(x,lower,'k',lw=2)
cbar.ax.get_yaxis().labelpad = 15
cbar.ax.set_ylabel(r'$\frac{\mathrm{d}\omega}{\mathrm{d}t}$',fontsize=22,fontweight='bold', rotation=0)
cs = contour(xx,yy,vol,levels=[0.5,10],colors=cmap[4],linewidths=2,linestyles='--')
savefig('w.pdf',format='pdf')

show()
