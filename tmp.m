%% Play with collapsing data
myrange = 1:3;

close all;
figure; 
myax = axes;
for i = myrange; 
    plot(casedata(i).synctime,casedata(i).intf_amp_norm./casedata(i).intf_amp_norm(casedata(i).time==10)-casedata(i).intf_amp_norm(casedata(i).time==10)); 
    hold on;
end


% a(t_sync) / a(t_scync=t_wave-end)
figure;
for i = myrange; 
    plot(casedata(i).synctime,casedata(i).intf_amp./casedata(i).intf_amp(casedata(i).time==10));
    hold on; 
end


% a(t) / a(t=t_wave-end)
figure;
for i = myrange;
    casedata(i).pa
    plot(casedata(i).time, casedata(i).intf_amp./casedata(i).intf_amp(casedata(i).time==10)./casedata(i).pa) ;
    hold on; 
end

% a(t)
figure;
for i = myrange; 
    plot(casedata(i).time,casedata(i).intf_amp);
    hold on; 
end



figure;
for i = myrange; 
    plot(casedata(i).time, sqrt(casedata(i).time.*casedata(i).circ)./casedata(i).intf_amp(casedata(i).time==10));
    hold on; 
end

% Sync up at the phase inversion and plot on log scales
figure;
ax = axes;
for i = myrange;
    synctime = casedata(i).time - casedata(i).time(casedata(i).intf_amp == min(casedata(i).intf_amp) ) + 10;
    plot(synctime, casedata(i).intf_amp);
    hold on; 
end
ax.YScale='log';
ax.XScale='log';



% Sync up at the phase inversion and plot on log scales, scale by circulation
% and a(t=t_wave-end)
fig = figure;
ax = axes;
for i = 1:3;
    synctime = casedata(i).time - casedata(i).time(casedata(i).intf_amp == min(casedata(i).intf_amp) ) + 10;
    intf_amp = casedata(i).intf_amp./ casedata(i).intf_amp(casedata(i).time==10) ;
    plot(synctime, intf_amp);
    hold on; 
end
ax.YScale='log';
ax.XScale='log';
axis tight
ax.XLim = [6,1000];
ax.XLabel = xlabel('Time, $t/(\ell/c_{air})$','interpreter','LaTeX');
ax.YLabel = ylabel('$a(t) / (\Gamma(t) / a_{wave-end})$','interpreter','LaTeX');

spiffyp(fig);

legend('5 MPa', '7.5 MPa', '10 MPa','location','best')


% Sync up at the phase inversion and plot on log scales, scale by max(circulation) at
% t= t_wave_end;
% and a0
fig = figure;
ax = axes;
for i = 1:3;
    time = casedata(i).time;
    synctime = casedata(i).time - casedata(i).time(casedata(i).intf_amp == min(casedata(i).intf_amp) ) + 10;
    intf_amp = (casedata(i).intf_amp)./ ( max(casedata(i).circ)/casedata(i).intf_amp(1)) ;
    intf_amp = (casedata(i).intf_amp)./ ( casedata(i).intf_amp(casedata(i).time==8)) ;
%     intf_amp = (casedata(i).intf_amp)./ ( min(casedata(i).circ(time>10))/casedata(i).intf_amp(1)) ;
    plot(synctime, intf_amp);
    hold on; 
end
ax.YScale='log';
ax.XScale='log';
axis tight
ax.XLim = [6,1000];
ax.XLabel = xlabel('Time, $t/(\ell/c_{air})$','interpreter','LaTeX');
ax.YLabel = ylabel('$a(t) / (\Gamma_{max} / a_0)$','interpreter','LaTeX');

spiffyp(fig);

legend('5 MPa', '7.5 MPa', '10 MPa','location','best')
figname = 'a_of_t_collapsed'
figpath = [diss_dir figname];



% Sync up at the phase inversion and plot on log scales, scale by circulation
% and a0
fig = figure;
ax = axes;
for i = 1:3;
    time = casedata(i).time;
    synctime = casedata(i).time - casedata(i).time(casedata(i).intf_amp == min(casedata(i).intf_amp) ) + 10;
    intf_amp = casedata(i).intf_amp./ (casedata(i).circ/casedata(i).intf_amp(1)) ;
    plot(synctime, intf_amp);
    hold on; 
end
ax.YScale='log';
ax.XScale='log';
axis tight
ax.XLim = [6,1000];
ax.XLabel = xlabel('Time, $t/(\ell/c_{air})$','interpreter','LaTeX');
ax.YLabel = ylabel('$a(t) / (\Gamma(t) / a_0)$','interpreter','LaTeX');

spiffyp(fig);

legend('5 MPa', '7.5 MPa', '10 MPa','location','best')
figname = 'a_of_t_collapsed'
figpath = [diss_dir figname];
if false
    export_fig(fig,figpath,'-pdf')
end

% Sync up at the phase inversion and plot on log scales, scale by circulation
% and a0
fig = figure;
ax = axes;
for i = 1:3;
    time = casedata(i).time;
    synctime = casedata(i).time - casedata(i).time(casedata(i).intf_amp == min(casedata(i).intf_amp) ) + 10;
    intf_amp = casedata(i).intf_amp./ (casedata(i).circ/casedata(i).intf_amp(1)) ;
    plot(synctime, intf_amp);
    hold on; 
end
% ax.YScale='log';
% ax.XScale='log';
axis tight
ax.XLim = [6,1000];
ax.XLabel = xlabel('Time, $t/(\ell/c_{air})$','interpreter','LaTeX');
ax.YLabel = ylabel('$a(t) / (\Gamma(t) / a_0)$','interpreter','LaTeX');

spiffyp(fig);

legend('5 MPa', '7.5 MPa', '10 MPa','location','best')
figname = 'a_of_t_collapsed'
figpath = [diss_dir figname];
if false
    export_fig(fig,figpath,'-pdf')
end


% Circulation plot

fig = figure;
ax = axes;
pai_=[5, 7.5, 10]*10^6;
for i = 1:3;
    time = casedata(i).time;
    synctime = casedata(i).time - casedata(i).time(casedata(i).intf_amp == min(casedata(i).intf_amp) ) + 10;
    circ = casedata(i).circ./pai_(i);
    plot(time, circ);
    hold on; 
end
% ax.YScale='log';
% ax.XScale='log';
axis tight
ax.XLim = [0,50];
ax.XLabel = xlabel('Time, $t/(\ell/c_{air})$','interpreter','LaTeX');
ax.YLabel = ylabel('$\Gamma(t)/p_a$','interpreter','LaTeX');

spiffyp(fig);

legend('5 MPa', '7.5 MPa', '10 MPa','location','best')
figname = 'circ_of_t_collapsed'
figpath = [diss_dir figname];
if false
    export_fig(fig,figpath,'-pdf')
end


% Look at increase in circulation from second part of wave
fig = figure;
ax = axes;
pai_=[5, 7.5, 10]*10^6;
for i = 1:3;
    time = casedata(i).time;
    synctime = casedata(i).time - casedata(i).time(casedata(i).intf_amp == min(casedata(i).intf_amp) ) + 10;
    intf_amp = casedata(i).intf_amp;
    circ = casedata(i).circ - casedata(i).circ(casedata(i).time==8);
    circ2 = abs((casedata(i).circ - casedata(i).circ(casedata(i).time==8))./(pai_(i)/( casedata(i).circ(casedata(i).time==8)./ casedata(i).circ(casedata(i).time==10) )));
    plot(time, circ2);
    hold on; 
end
% ax.YScale='log';
% ax.XScale='log';
axis tight
ax.XLim = [0,50];
ax.XLabel = xlabel('Time, $t/(\ell/c_{air})$','interpreter','LaTeX');
ax.YLabel = ylabel('$\Gamma(t)/p_a$','interpreter','LaTeX');

spiffyp(fig);

legend('5 MPa', '7.5 MPa', '10 MPa','location','best')
figname = 'circ_of_t_collapsed'
figpath = [diss_dir figname];
if false
    export_fig(fig,figpath,'-pdf')
end





%% Import interface location data (from python-ing)
if false
    clear; close all
    datadir = '/mnt/hdd/data/';
%     casetag='rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_25_100_roe';
    casetag='rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_1000_100';
    
    y0_str='_050_contours';
    
    
    load([datadir casetag '/y0' y0_str '.mat'])
    
    timesteps = length(y(:,1));
    time=1:timesteps
    
    figure;
    ax = axes;
    p = plot(x,y(1,:));
    ax.YLimMode='manual';
    ax.YLim=[min(y(:)),max(y(:))];
    ax.XLim=[0,1];
    
    for i = time
        p.YData = y(i,:);
        drawnow
%         pause(0.05)
    end
    
    % Calculate path length of curve defined by points at x,y. x in increasing
    % order
    arclength=@(X,Y) sum(sqrt( (X(2:end) - X(1:end-1)).^2 + (Y(2:end) - Y(1:end-1)).^2 ));
    
    % pathlength of the interface
    s=zeros(length(y(:,1)),1);
    
    for i = time
        s(i) = arclength(x, reshape(y(i,:),size(x)));
    end
    
    figure;
    ax2 = axes;
    plt=plot(1:timesteps,s)
    ax2.XScale='log';
    ax2.YScale='log';
%     ttmp = 
    ptmp=polyfit(log(time(time>ttmp)),log(intf_amp_norm(time>ttmp)),1);
    display(['Best fit logarithmic slope after t=' num2str(ttmp(1)) ' is ' num2str(ptmp(1)) ] )
    
    
    

%% (OLD) Import interface location data based on gmsh .pos output
elseif false
    
%     load([datadir casetag '/interface/interface' y0_str 'location.mat'])

% Indeces of x values at left side of interface, and last the last value
% x0 = [1; find(x(2:end)<x(1:end-1))+1; length(x)];

    
%     i0 = 1;
%     figure;
%     ax = axes;
%     ii=((x0(i0)):(x0(i0+1)-1));
%     p = plot(x(ii),y(ii));
%         ax.YLimMode='manual';
%     ax.YLim=[min(y),max(y)];
%     ax.XLim=[0,1];
%     
%     for i0=1:2%i0=(i0+1):(length(x0)-2);
%         ii=((x0(i0)):(x0(i0+1)-1));
%         p.XData = x(ii);
%         p.YData = y(ii);
%         drawnow
%         pause(1)
%     end
    
    %% Import d/dt(circulation)
elseif false
    clear; close all;
    
    holdflag = 'on'; if strcmp(holdflag,'on'); lnsty = '-'; else lnsty= '-'; end;
    
    pp_dir = '/hdd/Users/awesome/Dropbox/Research/Papers,etc/papers/2016_acoustic_vorticity/figs/lung_figs/';
    pp_dir = '/hdd/Users/awesome/Dropbox/Research/Papers,etc/prelim/figs/lung_figs/';
    figure; for i = 1:3; plot(casedata(i).synctime,casedata(i).intf_amp/casedata(i).intf_amp(casedata(i).time==10)-casedata(i).intf_amp(casedata(i).time==10)); hold on; end
    casedir_={'/mnt/hdd/data/rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_200_roe',...
        '/mnt/hdd/data/rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_200_rus'}
    
    
    casetag_ = {'rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_25_100_roe'}
    % %             'rmawave_0_10000000.0_0.03_0.1_0.0_1.0_1.0_25_100', ... %0.1 lambda rise distance
    % %             'rmawave_0_10000000.0_0.03_1.0_0.0_1.0_1.0_25_100', ... %1.0 lambda rise distance
    %             'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_100_roe', ... %5.0 lambda rise distance
    %             'rmawave_0_10000000.0_0.03_10.0_0.0_1.0_1.0_25_100'};  %10.0 lambda rise distance
    %              'rmawave_2_1000000.0_0.03_0.1_0.0_1.0_1.0_25_100_roe', ... %0.1 lambda rise distance
    %              'rmawave_2_5000000.0_0.03_0.1_0.0_1.0_1.0_25_100_roe', ... %0.1 lambda rise distance
    %              'rmawave_2_10000000.0_0.03_0.1_0.0_1.0_1.0_25_100_roe'}; %0.1 lambda rise distance
    
    
    
    for ncase=1
        casedir = ['/mnt/hdd/data/' casetag_{ncase} '/'];
        if ncase>1; lnsty='-'; end
        % cd('/mnt/hdd/data/rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_200_roe')
        %     cd(['/mnt/hdd/data/' casetag_{ncase}])
        delimiter=',';
        headerlines=1;
        % dGdt = importdata('ddt_circ.dat',delimiter,headerlines);
        dGdt = csvread([casedir 'ddt_circ.dat'],1,0);%,delimiter,headerlines);
        
        if isstruct(dGdt); dGdt=dGdt.data; end
        dt = 0.1;
        Time = dGdt(:,1)*dt;
        dGdt = dGdt(:,2:end); %separte time
        dGdt_total = dGdt(:,end);
        circ_int = cumtrapz(Time,dGdt_total);
        
        if false
            circ = importdata([casedir 'circ.dat']);
            if isstruct(circ); circ=circ.data; end
            circ = circ(1:length(Time),2);
            
            if false
                % Circulation calculated based on integration of vorticity vs curl of velocity
                figure(1); hold(gca, holdflag)
                plot(Time, [circ_int, circ], lnsty)
                xlabel('Time, t/(\lambda/c_{air})')
                ylabel('\Gamma')
            end
            
            
            if false
                % dGdT post processed in matlab vs gmsh
                figure(3); hold(gca, holdflag)
                plot(Time, [gradient(circ,Time), dGdt_total], lnsty)
                xlabel('Time, t/(\lambda/c_{air})')
                ylabel('total(d\Gamma/dt)')
            end
        end
        
        if true
            % Each component of dGdt
            figure(2); hold(gca, holdflag)
            plot(Time, dGdt, lnsty)
            xlabel('Time, $t/(\lambda/c_{air}$)','interpreter','LaTeX')
            ylabel('$d\Gamma/dt$','interpreter','LaTeX')
        end
        
        
    end
    
    %% Import and process vorticity and y0 sample data set
else
    %%
    clear; close all; clc
    cd('/mnt/hdd/data/rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_1000_100/test_data');
    
    x = 0.625; %CONSTANT, DETERMINED WHEN DATA WAS TAKEN
    t = 1; %CONSTANT, DETERMINED WHEN DATA WAS TAKEN
    
    % Import volume fraction contour
    y0_data = importdata('y0_test_data.pos');
    [~, y0y, ~, y0val] = twodposdata2array(y0_data);
    
    % Import vorticity contour
    w_data = importdata('vorticity_test.dat');
    [~, wy, ~, wval] = twodposdata2array(w_data);
    
    figure;
    plotyy(y0y, y0val, wy, wval)
    
    
    air_ind = (y0val<0.5);
    water_ind = (y0val>=0.5);
    circ1D_a = trapz(wy(air_ind), wval(air_ind));
    circ1D_w = trapz(wy(water_ind), wval(water_ind));
    
    circ1D_aw = abs(circ1D_a/circ1D_w)
    
    
    
    
    
    %%
end
% %% Starting to write a timeline function
%
% clc; clear;
%
% % function [time_line] = timeline(times, labels, varargin)
% times = [0:20:100];
% labels = {'','l1','l2','l3',''}
%
% % if exist('var','varargin')
% %     opts = parse_opts(varargin);
% % else
% %     opts = parse_opts()
% % end
%
% %Create time axes
% time_line = gobjects(3,1);
%
% ax = axes;
% ax.YLim=[0,0];
% ax.XAxisLocation='top'
% ax.XTick=times;
%
%
%
%
% time_line(1) = ax;
%
%
%
%
%
% % %%%%%%%%%%%%%
% sound_speed = @(gamma, rho, p, B) sqrt(gamma(p+B)/rho);
%
% % Dimensional variables
% rhoad=1.1765;
% gammaa=1.4;
% patmd=101325;
% cad=sqrt(gammaa*patmd/rhoad);
%
% rhowd=996;
% gammaw=5.5;
% pinfwd=492115000;
% cwd=sqrt(gammaw*(patmd+pinfwd)/rhowd);
%
% % Nondimensionaliztion parameters
% rho_scale=rhoad;
% p_scale=rhoad*cad^2;
% u_scale=cad;
%
% % Dimensionless variables
% rhoa=rhoad/rho_scale;
% patm=patmd/p_scale;
% ca=cad/u_scale;
%
% rhow=rhowd/rho_scale;
% pinfw=pinfwd/p_scale;
% cw=cwd/u_scale;
%
%
%
% %perturbation values
% pa = 10e6;
% cp
% rhop = pa/cp;
%
%
% vw = pa/(rhowd