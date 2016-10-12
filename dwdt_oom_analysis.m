clc
pad = 1e6; 
pa = pad/(1.1765*347.23^2);

rhoa=1;
ca=1;
rhow=846.6;
cw=4.75;

T = 2*(rhoa*ca)/(rhoa*ca+rhow*cw);

meansintheta=0.12;

advcomw=(pa/(rhow*cw))^2
advcoma=(pa*T/(rhoa*ca))^2

barow = pa*meansintheta / rhow
baroa = pa*meansintheta / rhoa


