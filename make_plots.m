clearvars, close all
% pp_dir = '/mnt/hdd/data/postproc/';
pp_dir = '/hdd/Users/awesome/Dropbox/Research/papers,etc/prelim/figs/lung_figs/';
diss_dir = '/hdd/Users/awesome/Dropbox/Research/papers,etc/dissertation/figs/lung_figs/';
% pp_dir = '/hdd/Users/awesome/Dropbox/Research/papers,etc/papers/2016_acoustic_vorticity/figs/lung_figs/';

casestr = 'multi-amp';%%'us-early';

casedata=struct('case',{},'time',[],'pa',[],'synctime',[],'intf_amp',[],'intf_amp_norm',[],'circ',[])

% Use this to keep 
datadir = '/mnt/hdd/data/';


% Define casetag and other variables for common cases
switch casestr
    case 'single-case'
        %         casetag_={'rmawave_1_10000000.0_0.03_45.0_0.0_1.0_1.0_25_100'};        
        casetag_={'rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_1000_100'};
        

        
        dtcoeff=1; %define dt
        %         event_times_=[0.063, 1.12, 8.49, 9.7];
        
    case 'multi-rho'
        casetag_ = {...
            'rmawave_2_10000000.0_0.03_45.0_0.0_0.1_1.0_5.0_500_100', ... %10 MPa TrapzWave (low-density)
            'rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_500_100', ... %10 MPa TrapzWave
            'rmawave_2_10000000.0_0.03_45.0_0.0_10.0_1.0_5.0_500_100'}; %10 MPa TrapzWave (high-density)
        %'rmawave_0_10000000.0_0.03_5.0_0.0_635.0_1.0_100_100'}; %10 MPa TrapzWave (high-density)
        dtcoeff=1.0; %define dt
        
        
    case 'multi-amp'
        casetag_ = {...
            ...'rmawave_2_1000000.0_0.03_45.0_0.0_1.0_1.0_5.0_500_100_roe', ... %01 MPa TrapzWave
            'rmawave_2_5000000.0_0.03_45.0_0.0_1.0_1.0_5.0_1000_100', ... %05 MPa TrapzWave
            'rmawave_2_7500000.0_0.03_45.0_0.0_1.0_1.0_5.0_1000_100', ... %07.5 MPa TrapzWave
            'rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_1000_100',...}; %10 MPa TrapzWave
            };...'rmawave_2_15000000.0_0.03_45.0_0.0_1.0_1.0_5.0_1000_100'}; %15 MPa TrapzWave
        dtcoeff=1.0; %define dt
        %         amp=[1e6,5e6,10e6]/(1.1765*347^2);
        %         event_times=[ ...
        %             0.063, 1.12, 8.49, 9.7;...
        %             0.063, 1.12, 8.49, 9.7;...
        %             0.063, 1.12, 8.49, 9.7];
        
    case 'hitres'
        casetag_ = {...
            'rmawave_2_1000000.0_0.03_45.0_0.0_1.0_1.0_5.0_25_100_roe', ... %1 MPa TrapzWave, early, high time resolution
            'rmawave_2_5000000.0_0.03_45.0_0.0_1.0_1.0_5.0_25_100_roe', ... %5 MPa TrapzWave, early, high time resolution
            'rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_25_100_roe', ... %10 MPa TrapzWave, early, high time resolution
            'rmawave_2_15000000.0_0.03_45.0_0.0_1.0_1.0_5.0_25_100'}; %15 MPa TrapzWave, early, high time resolution
        
        dtcoeff=0.1; %define dt
        amp=[1e6,5e6,10e6]/(1.1765*347^2);
        event_times_=[ ...
            0.063, 1.12, 8.49, 9.7;...
            0.063, 1.12, 8.49, 9.7;...
            0.063, 1.12, 8.49, 9.7;...
            0.063, 1.12, 8.49, 9.7];
        
    case 'multi-lag'
        casetag_ = {...
            'rmawave_2_10000000.0_0.03_10.0_0.0_1.0_1.0_5.0_25_100_roe', ... %10 MPa TrapzWave, early, high time resolution
            'rmawave_2_10000000.0_0.03_15.0_0.0_1.0_1.0_5.0_25_100_roe', ... %10 MPa TrapzWave, early, high time resolution
            'rmawave_2_10000000.0_0.03_25.0_0.0_1.0_1.0_5.0_25_100_roe', ... %10 MPa TrapzWave, early, high time resolution
            'rmawave_2_10000000.0_0.03_30.0_0.0_1.0_1.0_5.0_25_100_roe', ... %10 MPa TrapzWave, early, high time resolution
            'rmawave_2_10000000.0_0.03_35.0_0.0_1.0_1.0_5.0_25_100_roe', ... %10 MPa TrapzWave, early, high time resolution
            'rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_25_100_roe'}; %10 MPa TrapzWave, early, high time resolution
        dtlambda=1/4.748;
        event_times_ = [
            0.063, 1.12, 1.12+00*dtlambda, 1.12+5*dtlambda;...
            0.063, 1.12, 1.12+05*dtlambda, 1.12+10*dtlambda; ...
            0.063, 1.12, 1.12+15*dtlambda, 1.12+20*dtlambda; ...
            0.063, 1.12, 1.12+20*dtlambda, 1.12+25*dtlambda; ...
            0.063, 1.12, 1.12+25*dtlambda, 1.12+30*dtlambda; ...
            0.063, 1.12, 8.49, 9.7];
        
        dtcoeff=0.1; %define dt
        
    case 'multi-width'
        casetag_ = {...
            'rmawave_0_10000000.0_0.03_0.1_0.0_1.0_1.0_25_100', ... %0.1 lambda rise distance
            'rmawave_0_10000000.0_0.03_1.0_0.0_1.0_1.0_25_100', ... %1.0 lambda rise distance
            'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_100', ... %5.0 lambda rise distance
            'rmawave_0_10000000.0_0.03_10.0_0.0_1.0_1.0_25_100'};  %10.0 lambda rise distance
        
        dtcoeff=0.1; %define dt
        
    case 'convergence'
        casetag_ = {...
            'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_50', ... %50 cells/lambda grid
            'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_100', ... %100 cells/lambda grid
            'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_200'}; %200 cells/lambda grid
        
        dtcoeff=0.1; %define dt
        
    case 'riemann-solvers'
        casetag_ = {...
            %             'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_50', ... %50 cells/lambda grid
            %             'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_100', ... %100 cells/lambda grid
            'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_200_roe', ...
            %             'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_100_rus', ...
            'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_200_rus'}; %200 cells/lambda grid
        dtcoeff=0.1; %define dt
        
        
    case 'same-slope' % two ramp waves with the same slope, different amp, wave-width
        casetag_= {...
            'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_100', ... %
            'rmawave_0_20000000.0_0.03_10.0_0.0_1.0_1.0_25_100'};
        dtcoeff=0.1; %define dt
        
    case 'multi-domain' % two ramp waves with the same slope, different amp, wave-width
        casetag_= {...
            'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_100_rus', ... %
            'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_100_rus_long',...};
            'rmawave_0_10000000.0_0.03_5.0_0.0_1.0_1.0_25_100_roe'};
        dtcoeff=0.1; %define dt
        
    case 'us-early'
        casetag_= {...            
            'us_cases/rmawave_1_5000000.0_0.03_45.0_0.0_1.0_1.0_25_100', ...
            'us_cases/rmawave_1_10000000.0_0.03_45.0_0.0_1.0_1.0_25_100'...
            'us_cases/rmawave_1_15000000.0_0.03_45.0_0.0_1.0_1.0_25_100'...
            };
        dtcoeff = 0.1;
            
        
        
        
end

% Define other things
if ~exist('event_times_','var'); event_times = [0.063, 1.12, 8.49, 9.7]; end%Times at which various parts of pressure wave hit interface
event_labels = {'Positive gradient hits interface', 'Static pressure hits interface', 'Negative gradient hits interface', 'Acoustic wave leaves interface'};

if true %Compare variable cases
    intfplot = true; %Plot interface amplitude
    circplot = true;%true; %Plot circulation
    stress_plot = true;
    early_flag = false;
    intflogflag = true;
    label_flag = false;
    tag_flag = false;
    syncphaseinv_flag = true;
    bestfitline_flag = false;
    sqrtline_flag = false;
    flipfix_flag = true;
    
    mytag = [];
    
    ncases = length(casetag_);
    dt_=dtcoeff*ones(ncases,1);
    fig=gobjects(ncases,1);
    linec=flipud(lines(ncases));
    
    fig = figure;
    ax(1) = axes; hold on
    fig(2) = figure;
    ax(2) = axes; hold on
    
    %Prealocate variables
    
    t0_=-1*ones(ncases,1);
    time =[]; intf=[]; circ=[];
    intf_lines=gobjects(ncases,1);
    intf_scats=gobjects(ncases,1);
    circ_lines=gobjects(ncases,1);
    
    pa=[1,5,7.5,10,15]*1e6;
    
    
    
    for n = 1:ncases;
        casetag=casetag_{n};
        dt = dt_(n);
        thiscolor=linec(ncases+1-n,:);
        
        if ~exist('event_times_','var');
            event_times = [];%[0.063, 1.12, 8.49, 9.7];
        else
            event_times = event_times_(n,:);
        end%Times at which various parts of pressure wave hit interface
        
        
        % Import and prepare interface minimum and maximum location data
        if intfplot
            intf0 = importdata([datadir casetag '/interface_minmax.dat']);
            if isstruct(intf0); intf0 = intf0.data; end
            
            time = intf0(:,1)*dt;
            good = time>t0_(n);
            time = time(good);
            intf0 = intf0(good,:);
            intf_amp = intf0(:,3) - intf0(:,2);
            intf_amp_norm = intf_amp./intf_amp(1);
            
            %%DELETE ME
            %             intf_amp_norm = intf_amp./intf_amp(time==10);
            
            % offset interface time by phase reversal time
            %             if intflogflag; time = time-time(intf_amp_norm==min(intf_amp_norm)); end
            
            % Interface amplitudes at time of wave events
            event_amps=interp1(time, intf_amp_norm, event_times,'linear');
            
            
            % Create figure of interface amplitude vs time
            figure(fig(1));
            axes(ax(1));hold on
            %             intf_lines(n)=plot(time,intf_amp_norm,'linewidth',2, 'color',thiscolor);
            intf_lines(n)=plot(time,intf_amp_norm,'linewidth',2, 'color',thiscolor);
            intf_scats(n)=scatter(event_times,event_amps,100,'kx','linewidth',2);
            ax(1).XLabel=xlabel('Time, $t/(\lambda/c_{air})$','interpreter','LaTeX');
            ax(1).YLabel=ylabel('Interface amplitude, $a(t)/a_0$','interpreter','LaTeX');
            
            casetext(n)=text(0,0,casetag,'Units','normalized','Parent',ax(1));
            casetext(n).String(casetext(n).String=='_')='-';
            
            box on
            fig(1)=spiffyp(fig(1),'square');
            [casetext.FontSize]=deal(10);
            
            casetext(n).Position = [.97-casetext(n).Extent(3), (ncases-n+1)*0.03, casetext(n).Position(3)];
            %             line([0.95,0.99]*casetext(n).Position(1)*range(ax(1).XLim), [1,1]*casetext(n).Position(2)*range(ax(1).YLim),'color',thiscolor);
            
            figstr1 = [diss_dir 'interface_' casestr];
            
            % Look at the slope of the log after t=249
            ttmp = 500; ttmp2=1000;%cutoff time
            if bestfitline_flag %&& max(time) > ttmp;
                if max(time) > ttmp2; ttmp2 = max(time); end
                ptmp=polyfit(log(time(time>ttmp & time < ttmp2)),log(intf_amp_norm(time>ttmp & time < ttmp2)),1);
                %                 ptmp=polyfit(log(time(time>ttmp)),log(intf_amp_norm(time>ttmp)),1);
                display(['Best fit logarithmic slope after t=' num2str(ttmp(1)) ' is ' num2str(ptmp(1)) ' for pa= ' num2str(pa(n)/1e6)  ' MPa'] )
            end
            
        end
        
        % Create figure of circulation vs time
        if circplot
            % Import and prepare interface minimum and maximum location data
            circ=importdata([datadir casetag '/circ.dat']);
            if isstruct(circ); circ = circ.data; end
            time = circ(:,1)*dt; % extract time
            good = time>t0_(n); % grab only time locations after point of interest (currently t=0)
            time = time(good);
            circ=circ(good,2);
            
            % some old cases calculate the opposite of circulation, this fixes that
            if flipfix_flag && (max(circ) < max(abs(circ)))
                circ = -circ;
            end
            
            % Interface amplitudes at time of wave events
            event_circ=interp1(time, circ, event_times,'linear');
            
            figure(fig(2));
            axes(ax(2));
            
%                         circ_lines(n)=plot(time,circ,'linewidth',2,'color',thiscolor);
%                         scatter(event_times,event_circ,100,'kx','linewidth',2)
            
            %             Circulation normalized by pa
            plot(time,circ,'linewidth',2,'color',thiscolor);
            scatter(event_times,event_circ/pa(n),100,'kx','linewidth',2)
            
            ax(2).XLabel=xlabel('Time, $t/(\lambda/c_{air})$','interpreter','LaTeX');
            ax(2).YLabel=ylabel('Circulation, $\Gamma$','interpreter','LaTeX');
            
            casetext2(n)=text(0,0,casetag,'Units','normalized','Parent',ax(2));
            casetext2(n).String(casetext2(n).String=='_')='-';
            
            
            box on
            fig(2)=spiffyp(fig(2),'square');
            [casetext2.FontSize]=deal(10);
            %             casetext2(n).Position = [.97-caset xt2(n).Extent(3), 0.03*n, casetext2(n).Position(3)];
            if n == 1
                casetext2(n).Position = [.97-casetext(n).Extent(3), (ncases-n+1)*0.03, casetext(n).Position(3)];
            else
                casetext2(n).Position = [ min([0.97-casetext(n).Extent(3), casetext(1).Position(1)] ), (ncases-n+1)*0.03, casetext(n).Position(3)];
            end
            %             line([0.95,0.99]*casetext2(n).Position(1)*range(ax(2).XLim), [1,1]*casetext2(n).Position(2)*range(ax(2).YLim),'color',thiscolor);
            figstr2 = [diss_dir 'circulation_' casestr];
        end
        
        % Add asymptotic sqrt(gamma*t) line interface amplitude plots
        if circplot && intfplot && intflogflag
            axes(ax(1))
            ax(1).XScale='log';
            ax(1).YScale='log';
            %                 xa = time(time>sqrt(time(end))); %Last half of time on a log plot
            
            
            xa = time(time>max(time/10)); %Last half of time on a log plot
            ya = sqrt(xa*circ(end))*(max(intf_amp_norm)/max(sqrt(xa*circ(end))))*1.05;
            if sqrtline_flag
                plot(xa,ya,'LineStyle','--','Color',thiscolor)
                text(min(xa),min(ya)*1.31,'$\sim\sqrt{t\Gamma_{f}}$','rotation',rad2deg(atan(0.5)),'interpreter', 'LaTeX','Color',thiscolor)
            end
            figstr1 = [figstr1 '_loglog'];
            
            
            
            if bestfitline_flag
                hold on
                expon = ptmp(1);
                ya2 = (xa*circ(end)).^expon*(max(intf_amp_norm)/max(sqrt(xa*circ(end))))*1.01;
                
                plot(xa,ya2,'LineStyle','--','Color','r')
                text(min(xa),min(ya2)^expon,['$\sim\left(t\Gamma_{f}\right)^{' sprintf('%0.2f',expon) '}$'],'rotation',rad2deg(atan(0.5)),'interpreter', 'LaTeX','Color','r')
            end
        end
        
        if stress_plot
            
        end
        
        % Use to plot change in circulation caused by expansion wave vs
        % interface amplitude at the time (needs a bit of finessing, but works
        % well)
        %         dGamma(n)=circ(find(time<event_times(4),1,'last')) - circ(find(time<event_times(3),1,'last'));
        %         intfampexp(n)=intf_amp_norm(find(time<event_times(3),1,'last'));
        %         intfampexp(1:3)=-intfampexp(1:3)
        %         plot(intfampexp,dGamma)
        
        
        %%%%% DELETE MEEEEEEEEE %%%%%%%%%%%%%
        %         if n == 3; time = time(1:300); intf_amp = intf_amp(1:300); intf_amp_norm = intf_amp_norm(1:300); circ=circ(1:300); end
        
        casedata(n).case = casetag;
        casedata(n).time = time;
        casedata(n).pa = pa(n);
        casedata(n).synctime=time - time(intf_amp==min(intf_amp));
        casedata(n).intf_amp = intf_amp;
        casedata(n).intf_amp_norm = intf_amp_norm;
        casedata(n).circ = circ;
    end
    
    % Fix sync time
    toff = min(vertcat(casedata.synctime));
    %     for nc=1:ncases; casedata(n).synctime = casedata(n).synctime - toff; end
    
    
    %Plot mods outside loop
    
    
    % Label things
    if label_flag
        if intfplot
            casetext(n+1)=copyobj(casetext(1), casetext(1).Parent); %Add casestr for comparative plots
            casetext(n+1).String=casestr;
            casetext(n+1).Position(2)=casetext(1).Position(2)+0.03;
            if ax(1).XLim(2)>25 && early_flag; [ax(1).XLim]=deal([0, 25]); figstr1=[figstr1 '_early']; end %Zoom in early
            
            %Lines to label legend
            for nc = 1:ncases
                line([0.95,0.99]*casetext(nc).Position(1)*range(ax(1).XLim), [1,1]*casetext(nc).Position(2)*range(ax(1).YLim)+ax(1).YLim(1),'color',linec(ncases+1-nc,:),'parent',ax(1));
            end
        end
        
        if circplot
            casetext2(n+1)=copyobj(casetext2(1), casetext2(1).Parent);
            casetext2(n+1).String=casestr;
            casetext2(n+1).Position(2)=casetext2(1).Position(2)+0.03;
            if ax(2).XLim(2)>25 && early_flag; [ax(2).XLim]=deal([0, 25]); figstr1=[figstr2 '_early']; end %Zoom in early
            
            %Lines to label legend
            for nc = 1:ncases
                line([0.95,0.99]*casetext2(nc).Position(1)*range(ax(2).XLim), [1,1]*casetext2(nc).Position(2)*range(ax(2).YLim)+ax(2).YLim(1),'color',linec(ncases+1-nc,:),'parent',ax(2));
            end
        end
    else
        delete(casetext)
        delete(casetext2)
    end
    
    if syncphaseinv_flag
        
        % Playing around, trying to get curves to fall on one another
        if false
            for nc=1:ncases
                
                intf_lines(nc).XData = intf_lines(nc).XData*pa(nc);
                
                intf_lines(nc).YData = intf_lines(nc).YData./abs(circ_lines(nc).YData).^0.6;
                %             intf_lines(nc).YData = intf_lines(nc).YData./abs(circ_lines(nc).YData).^0.6;
                
                % Remove unreal values
                badvals = abs(intf_lines(nc).YData) > 10^10 | abs(intf_lines(nc).YData) < 10^-10;
                intf_lines(nc).XData(badvals)= [];
                intf_lines(nc).YData(badvals)= [];
                
                ax(1).XLabel.String = 'Adjusted Time, $t/(\lambda/c_{air}) p_a$';
                ax(1).YLabel.String = 'Adjusted amplitude, $(a(t)/a_0)\left|\Gamma\right|^{0.60}$'
            end
            
            
            
            for nc = 1:ncases
                % Get time shift to sync phase inversions
                t_phaseinvs(nc) = intf_lines(nc).XData(intf_lines(nc).YData==min(intf_lines(nc).YData));
            end
            t_shift = t_phaseinvs-max(t_phaseinvs);
            for nc = 1:ncases
                % Apply time shift
                intf_lines(nc).XData = intf_lines(nc).XData - t_shift(nc);
            end
            
            intf_lines0 = intf_lines;
        end
        
        
    end
    
    spiffyp(gcf);
    
    
    % Add to file names
    if tag_flag; figstr1=[figstr1 mytag]; figstr2=[figstr2 mytag]; end
    
    % Save interface amplitude plot
    if intfplot && false
        savefig(fig(1),[figstr1 '.fig'] ,'compact')
        export_fig(fig(1),figstr1 ,'-jpg', '-r400');
        export_fig(fig(1),figstr1 ,'-jpg', '-pdf');
    end
    
    
    % Save circulation history plot
    if circplot && false
        savefig(fig(2),[figstr2 '.fig'] ,'compact')
        export_fig(fig(2),figstr2 ,'-jpg', '-r400');
    end
    
    
    
    
    
end








%
%
%
%
%
%
%
%
%
%
%
%
% elseif false
%     % casetag_ = {'rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_500_100'}; %10 MPa TrapzWave
%     % casetag_ = {'rmawave_2_5000000.0_0.03_45.0_0.0_1.0_1.0_5.0_500_100'};  %05 MPa TrapzWave
%     % casetag_ = {'rmawave_2_1000000.0_0.03_45.0_0.0_1.0_1.0_5.0_500_100'};  %01 MPa TrapzWave
%     % casetag_ = {'rmawave_2_10000000.0_0.03_25.0_0.0_1.0_1.0_5.0_500_100'}; %10 MPa TrapzWave (shortened)
%     % casetag_ = {'rmawave_2_10000000.0_0.03_45.0_0.0_10.0_1.0_5.0_500_100'}; %10 MPa TrapzWave (high-density)
%     casetag_ = {'rmawave_2_10000000.0_0.03_45.0_0.0_0.1_1.0_5.0_500_100'}; %10 MPa TrapzWave (low-density)
%     % casetag_ = {'rmawave_1_10000000.0_0.03_45.0_0.0_0.1_1.0_500_100'}; %10 MPa US Wave
%
%     dt_=[1];
%     t0_=[-1];
%     time =[]; intf=[]; circ=[];
%     for n = 1:length(casetag_);
%         casetag=casetag_{n};
%         intf0 = importdata(['../' casetag '/interface_minmax.dat']);
%         intf0 = intf0.data;
%         dt = dt_(n);
%         time0 = intf0(:,1)*dt;
%         good = time0>t0_(n);
%         time0 = time0(good);
%         intf0 = intf0(good,:);
%         intf_amp = intf0(:,3) - intf0(:,2);
%         intf_amp_norm = intf_amp./intf_amp(1);
%
%         circ=importdata(['../' casetag '/circ.dat']);
%         circ=circ.data;
%         circ=circ(good,2);
%
%         time = [time0];
%     end
%     %     intf_amp = intf(:,3) - intf(:,2);
%     %     intf_amp_norm = intf_amp./intf_amp(1);
%
%
%
%     fig(1) = figure;
%     ax(1) = axes; hold on
%     p=plot(time,intf_amp_norm,'linewidth',2);
%     %     plot(time, sqrt((max(circ)*time)/intf_amp(1)) + -.8,'--','linewidth',2)
%     % plot(time, sqrt((max(circ)*time)/intf_amp(1)) + 7.2,'--','linewidth',2)
%     xlabel('Time, t/(\lambda/c_{air})');
%     ylabel('Interface amplitude, a(t)/a_0');
%     text(20,10,'$(t\Gamma_{max})/a_0 + k$','rotation',30,'interpreter', 'LaTeX')
%     casetext=text(0,0,casetag,'Units','normalized','Parent',ax(1));
%     casetext.String(casetext.String=='_')='-'
%
%     box on
%     spiffyp(fig(1),'square');
%     casetext.FontSize=10;
%     casetext.Position = [.97-casetext.Extent(3), 0.03, casetext.Position(3)];
%
%     figstr1 = [pp_dir 'interface_' casetag];
%
%     if false
%         savefig(fig(1),[figstr1 '.fig'] ,'compact')
%         export_fig(fig(1),figstr1 ,'-jpg', '-r400');
%     end
%
%
%     fig(2) = figure;
%     ax(2) = axes; hold on
%     %     ax(2).XLim=[0,30];
%     plot(time,circ,'linewidth',2);
%     %     line([0, ax(2).XLim(2)], [0, 0], 'Color','r','linestyle','--')
%     xlabel('Time, t/(\lambda/c_{air})');
%     ylabel('Circulation, \Gamma');
%     text(60,4.7e-3,'$\Gamma=\int_{\Omega/2}\left(\nabla\times\vec{\omega}\right)dA$','interpreter', 'LaTeX')
%     casetext=text(0,0,casetag,'Units','normalized','Parent',ax(2));
%     casetext.String(casetext.String=='_')='-'
%
%     box on
%     spiffyp(fig(2),'square')
%     casetext.FontSize=10;
%     casetext.Position = [.97-casetext.Extent(3), 0.03, casetext.Position(3)];
%     figstr2 = [pp_dir 'circulation_' casetag];
%
%     if false
%         savefig(fig(2),[figstr2 '.fig'] ,'compact')
%         export_fig(fig(2),figstr2 ,'-jpg', '-r400');
%     end
% end
%
% %Useful lines that were commented or removed
%
% % Individual casetags of relevance
% % casetag_ = {'rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_500_100'}; %10 MPa TrapzWave
% % casetag_ = {'rmawave_2_5000000.0_0.03_45.0_0.0_1.0_1.0_5.0_500_100'};  %05 MPa TrapzWave
% % casetag_ = {'rmawave_2_1000000.0_0.03_45.0_0.0_1.0_1.0_5.0_500_100'};  %01 MPa TrapzWave
% % casetag_ = {'rmawave_2_10000000.0_0.03_25.0_0.0_1.0_1.0_5.0_500_100'}; %10 MPa TrapzWave (shortened)
% % casetag_ = {'rmawave_2_10000000.0_0.03_45.0_0.0_10.0_1.0_5.0_500_100'}; %10 MPa TrapzWave (high-density)
% % casetag_ = {'rmawave_2_10000000.0_0.03_45.0_0.0_0.1_1.0_5.0_500_100'}; %10 MPa TrapzWave (low-density)
% % casetag_ = {'rmawave_1_10000000.0_0.03_45.0_0.0_0.1_1.0_500_100'}; %10 MPa US Wave
%
% % Create reference line at y=0
% %     line([0, ax(2).XLim(2)], [0, 0], 'Color','r','linestyle','--')
%
% % Create text labeling asymptotic line that circulation is expected to hit
% %     text(60,4.7e-3,'$\Gamma=\int_{\Omega/2}\left(\nabla\times\vec{\omega}\right)dA$','interpreter', 'LaTeX')
%
%
% %     plot(time, sqrt((max(circ)*time)/intf_amp(1)) + -.8,'--','linewidth',2)
% % plot(time, sqrt((max(circ)*time)/intf_amp(1)) + 7.2,'--','linewidth',2)
%
% % % Dimensional variables
% % rhoad=1.1765;
% % gammaa=1.4;
% % patmd=101325;
% % cad=sqrt(gammaa*patm/rhoa);
% %
% % rhowd=996;
% % gammaw=5.5;
% % pinfwd=492115000;
% % cwd=sqrt(gammaw*(patm+pinfwd)/rhowd);
%
% % % Nondimensionaliztion parameters
% % rho_scale=rhoad;
% % p_scale=rhoad*cad^2;
% % u_scale=cad;
% %
% % % Dimensionless variables
% % rhoa=rhoad/rho_scale;
% % patm=patmd/p_scale;
% % ca=cad/u_scale;
% %
% % rhow=rhowd/rhow_scale;
% % pinfw=pinfwd/p_scale;
% % cw=cwd/u_scale;
%
