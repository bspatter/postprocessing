%% Import interface location data (from python-ing)

clear; close all
datadir = '/mnt/hdd/data/';
%     casetag='rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_25_100_roe';
casetag='rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_1000_100';

y0_str='_050_contours';


load([datadir casetag '/y0' y0_str '.mat'])

timesteps = length(y(:,1));
time=[1:timesteps]';

figure;
ax = axes;
p = plot(x,y(1,:));
ax.YLimMode='manual';
ax.YLim=[min(y(:)),max(y(:))];
ax.XLim=[0,1];
% 
for i = 1:timesteps
    p.YData = y(i,:);
    drawnow
    %         pause(0.05)
end

% Calculate path length of curve defined by points at x,y. x in increasing
% order
arclength=@(X,Y) sum(sqrt( (X(2:end) - X(1:end-1)).^2 + (Y(2:end) - Y(1:end-1)).^2 ));

% pathlength of the interface
s=zeros(length(y(:,1)),1);

for i = 1:timesteps
    s(i) = arclength(x, reshape(y(i,:),size(x)));
end

% Find best fit line
ttmp = 200;
xtmp = ttmp:timesteps;
ytmp = sqrt(xtmp*s(end))*(max(s)/max(sqrt(xtmp*s(end))))*1.05;
ptmp=polyfit(log(time(time>ttmp)),log(s(time>ttmp)),1);
display(['Best fit logarithmic slope after t=' num2str(ttmp(1)) ' is ' num2str(ptmp(1)) ] )

% Plot lines
fig2=figure; hold on
% ax2 = axes; 
plt21=plot(time,s); hold on
plt22=plot(xtmp,ytmp+2,'Color',plt21.Color,'LineStyle','--')

set(gca,'XScale','log')
set(gca,'YScale','log')
% ax2.XScale='log';
% ax2.YScale='log';
xlabel('Time, $t/(\lambda/c_{air})$','interpreter','LaTeX');
ylabel('Arc length, $s(t)$','interpreter','LaTeX');

outdir='/hdd/Users/awesome/Dropbox/Research/papers,etc/group_meetings/20160714_patterson_interface_arclength/';
if false
    export_fig(gcf,[outdir 'arclength'], '-pdf')
end




