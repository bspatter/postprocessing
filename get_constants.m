% Dimensional variables
rhoad=1.1765;
mma=28.966; % Molecular weight air
gammaa=1.4;
pinfad=0;
patmd=101325;
cad=sqrt(gammaa*patmd/rhoad);
nuad = 1.6636e-5; %kinematic visc (m^2/s) @ 37C

rhowd=996;
mmw=18.01528;
gammaw=5.5;
pinfwd=492115000;
cwd=sqrt(gammaw*(patmd+pinfwd)/rhowd);
nuwd = 7e-7;
sigmawd=0.072; % N/m @ 298K

% Nondimensionaliztion parameters
rho_scale=rhoad;
p_scale=rhoad*cad^2;
u_scale=cad;
l_scale=200e-6; % a 100 micron alveolus
t_scale = l_scale/u_scale;

% Dimensionless variables
rhoa=rhoad/rho_scale;
pinfa=pinfad/p_scale;
patm=patmd/p_scale;
ca=cad/u_scale;
nua=nuad/(u_scale*l_scale);

rhow=rhowd/rho_scale;
pinfw=pinfwd/p_scale;
cw=cwd/u_scale;
nuw=nuwd

% Dimensional Acoustic parameters
dpd = 10e6; % (Pa)
dud = dpd/(rhowd*cwd);
drhod = dpd/(cwd^2);

dp = dpd/p_scale; %acoustic pressure1e 7
du = dud/u_scale;
drho = drhod/rho_scale;



% Interface region
delta=0.08;
yy=-1:0.001:1;
d=(delta-yy)./(2*delta);
% d = 0:0.001:1;
alpha_=ones(size(d));
alpha_(d>0 & d<1) = exp(log(1e-16)*power(abs(d(d>0 & d<1)),8));
alpha_(d>1)=0;
rho_ = rhow*alpha_ + rhoa*(1-alpha_);

if false
    fig(3)=figure;
    ax(3)=axes;
    plt=plot(yy,rho_)
    ax(3).XLabel=xlabel('$y$','interpreter','LaTeX');
    ax(3).YLabel=ylabel('Density, $\rho$','interpreter','LaTeX');
    spiffyp(fig(3));
    
    ax(3).XLim=[-1,1]*0.5
    
    export_fig(fig(3),'/hdd/Users/awesome/Dropbox/Research/papers,etc/prelim/slides/figs/interface_density','-pdf')
    savefig(fig(3),'/hdd/Users/awesome/Dropbox/Research/papers,etc/prelim/slides/figs/interface_density','compact')
end


%Acoustic transmission coefficient
T=2*rhoa*ca/(rhoa*ca+rhow*cw);

T*(rhow/rhoa)^2;

dwdt_rho_ratio = T.*(rhow./rho_).^2; 

plot(alpha_,dwdt_rho_ratio)




% Quantities of abribtrary water-air mixture adjusted for volume fraction
alpha = 0.0000001:0.001:1;
rho_f = alpha.*rhow + (1-alpha).*rhoa;
gamma_f = 1./( (1-alpha)./(gammaa-1) +alpha./(gammaw-1))+1;
pinf_f = ( (1./(alpha./(gammaw*(patm+pinfw))+(1-alpha)./(gammaa*patm))-gamma_f*patm)./gamma_f );
c_f=sqrt(gamma_f.*(patm+pinf_f)./rho_f);
% c_f=sqrt(1/ (( (1-alpha)/(rhoa*ca^2) + (alpha/(rhow*cw^2)) )*rho_f) ); % A
% check on the above, should be the same

T_f = 2*rho_f.*c_f./(rho_f.*c_f+rhow*cw);
baro_ratio_f=T_f.*(rhow./rho_f).^2;
% plot(alpha,baro_ratio_f)



% Acoustic velocities (currently divided bd 
uawd = dpd/10/(rhowd*cwd);
uaad = (dpd/10)*T/(rhoad*cad);

% Reynolds number
Rea = rhoad*uaad*l_scale/nuad;
Rew = rhowd*uawd*l_scale/nuwd;

% Webber number
sigma_lung = 0.009;
Wea = inf;
Wed = rhowd*cwd^2*l_scale/sigmawd;
Wel = rhowd*(dpd/10/(rhowd*cwd))^2*l_scale/sigma_lung;
Wel = rhowd*(dpd/10*l_scale/sigma_lung);

% Cauchy number =
Rea = rhoad*uaad*l_scale/nua;
Rea = rhoad*uaad*l_scale/nua;




% Viscous layer thickness
if false
    fig(4)=figure;
    ax(4)=axes;
    ttmp=0:1000;
    delta_thick=sqrt(nua*ttmp);
    plt=plot(ttmp,delta_thick);
    ax(4).XLabel=xlabel('Time $t/(\lambda/c_{air})$','interpreter','LaTeX');
    ax(4).YLabel=ylabel('Viscous layer thickness, $\delta=\sqrt{\nu t}$','interpreter','LaTeX');
    spiffyp(fig(4));
          
    export_fig(fig(4),'/hdd/Users/awesome/Dropbox/Research/papers,etc/prelim/slides/figs/viscous_layer','-pdf')
    savefig(fig(4),'/hdd/Users/awesome/Dropbox/Research/papers,etc/prelim/slides/figs/viscous_layer','compact')
end




%%
% Plot of roughly how much relative circulation should go as alpha
% binsize = 0.0005;
% binnum = ceil(alpha/binsize);
% binsum = accumarray(binnum(:), baro_ratio_f(:));
% binmaxs=(1:size(binsum,1))*binsize;
% binsum_area = sum(binsum*binsize);
% 
% fig(2)=figure;
% ax(2)=axes;
% bar(binmaxs, binsum/binsum_area);
% ax(2).YLabel=ylabel('Circulation Distribution', 'interpreter','LaTeX');
% ax(2).XLabel=xlabel(' Volume Fraction $y_0$', 'interpreter','LaTeX');
% ax(2).XLim=[0,1];
% spiffyp(fig(2));

% y0c=0.99; %Cut-off volume fraction for air v water
% % Portion of vorticity in air/water dominated fluid
% circ_air_frac = sum(baro_ratio_f/sum(baro_ratio))
% %circ_air_frac = trapz(binmaxs(binmaxs<y0c), binsum(binmaxs<y0c)/binsum_area); %Check of the above, should be same
% 
% circ_water_frac = sum(vort_intf(y0_intf>=y0c))/sum(vort_intf) 
% %circ_water_frac = trapz(binmaxs(binmaxs>=y0c), binsum(binmaxs>=y0c)/binsum_area); %Check of the above, should be same
% 
% circ_air_water_ratio = circ_air_frac/circ_water_frac
% 



% Weird version with molecular weights
% mm_f = 1/(alpha/mmw + (1-alpha)/mma);
% gamma_f = ((1/((alpha/mmw)+((1-alpha)/mma))*(alpha/(gammaw-1)*1/mmw+(1-alpha)/(gammaa-1)*1/mma))*mm_f)^-1+1;
% pinf_f = ((1/((alpha/mmw)+((1-alpha)/mma))*(alpha/(gammaw*pinfw-1)*1/mmw+(1-alpha)/(gammaa*pinfa-1)*1/mma))^-1+1)/gamma_f %Need B of fluid

%% Calculate circ by integrating baroclinic term over dt=Delta_la/c_w

dL_I = 0.04;
drho_I = (rhow-rhoa);
dL_a = 5;
dt = dL_a/cw;
theta=0.1;

y0 = 0.25;
rhomix = y0*rhow + (1-y0)*rhoa;

dwdt = (drho_I/dL_I)*(T*dp/dL_a)/(rhomix^2)*dt



%% Calculate intensity of trapz wave
L_trapw=45;
x_trapw=0:0.01:45;
t_trapw=x_trapw/cw;
p_trapw=zeros(size(x_trapw));
p_trapw(x_trapw<dL_a)=dp/dL_a.*x_trapw(x_trapw<dL_a);
p_trapw(x_trapw>=dL_a & x_trapw<=(L_trapw-dL_a))=dp;
p_trapw(x_trapw>(L_trapw-dL_a))=dp-dp*(x_trapw(x_trapw>(L_trapw-dL_a))-(L_trapw-dL_a) )./dL_a;
u_trapw=p_trapw./(rhow*cw); %May not be totally correct physically, but checks with code

Intensity_trapw = trapz(t_trapw, p_trapw.*u_trapw)/max(t_trapw);
Intensity_trapw_d = Intensity_trapw*(p_scale^2/(rho_scale*u_scale)); %W/m^2







