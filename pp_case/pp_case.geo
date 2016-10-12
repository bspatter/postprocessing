// Post process case


Merge "./mesh.msh";

NUM_TIME = 250 +1;
NUM_PROCS = 6;

NP=NUM_PROCS;
Nt=NUM_TIME;

Include "./interface_minmax.geo";
Include "./circ.geo";
Include "./viscous_stress.geo";

If (1<0)
Include "./y0pos2txt.geo";
System "python ./y0_contours.py";
System "rm ./y00000*.txt";
EndIf
