close all; clear all; clc

out_path = [dropbox_path 'Research/papers,etc/dissertation/figs/'];

delta_=[0.1,0.5,1,2,10]*0.08; 
patm=0.714285714285714;
pin = 71.208805 - patm;
pR = abs([-69.146517, -69.146099, -69.146103, -69.145422, -69.254251]-patm);


R = pR./pin;

figure;
scatter(delta_,R,'filled'); hold on
scatter(delta_(3),R(3),'r','filled');

xlabel('Interface thickness parameter $\delta$','Interpreter','LaTeX')
ylabel('Acoustic reflection coefficient ${R}$','Interpreter','LaTeX')

set(gca, 'YLim', [0.99,1])

spiffyp(gcf)
box on

export_fig(gcf,[out_path 'delta_R'],'pdf');
export_fig(gcf,[out_path 'delta_R'],'-r400','-jpg');
savefig(gcf,[out_path 'delta_R'],'compact')