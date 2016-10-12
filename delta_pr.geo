/* Output the circulation and the density weighted enstrophy to a file.*/

Merge "./deltchk_2_10000000.0_0.03_45.0_0.0_10_5.0_50_100/mesh.msh";


// Loop on time and output the values
fout = 'delta_pr.dat';
Printf("# delta      pI+patm      pR+patm   ") > fout;
Printf("") >> fout;

NP = 6;


t0 = 0;
t1 = 50;


// MPI output (Creates new views)
delta=0.1;
For k In {0:NP-1}
Merge Sprintf("./deltchk_2_10000000.0_0.03_45.0_0.0_%0.1f_5.0_50_100/p%010.0f.pos%.0f",delta,t0,k);
Merge Sprintf("./deltchk_2_10000000.0_0.03_45.0_0.0_%0.1f_5.0_50_100/p%010.0f.pos%.0f",delta,t1,k);
EndFor

View[0].TimeStep=t0;
// Save maximum and minimum pressures
Printf("%0.1f       %f,       %f", delta, View[0].Max, View[0].Min) >> fout;

Delete View[0];


// MPI output (Creates new views)
delta=0.5;
For k In {0:NP-1}
Merge Sprintf("./deltchk_2_10000000.0_0.03_45.0_0.0_%0.1f_5.0_50_100/p%010.0f.pos%.0f",delta,t0,k);
Merge Sprintf("./deltchk_2_10000000.0_0.03_45.0_0.0_%0.1f_5.0_50_100/p%010.0f.pos%.0f",delta,t1,k);
EndFor

View[0].TimeStep=t0;
// Save maximum and minimum pressures
Printf("%0.1f       %f,       %f", delta, View[0].Max, View[0].Min) >> fout;

Delete View[0];


// MPI output (Creates new views)
delta=1.0;
For k In {0:NP-1}

Merge Sprintf("/mnt/hdd/data/rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_25_100_roe/p%010.0f.pos%.0f",t0,k);
Merge Sprintf("/mnt/hdd/data/rmawave_2_10000000.0_0.03_45.0_0.0_1.0_1.0_5.0_25_100_roe/p%010.0f.pos%.0f",100,k);
EndFor

View[0].TimeStep=t0;
// Save maximum and minimum pressures
Printf("%0.1f       %f,       %f", delta, View[0].Max, View[0].Min) >> fout;

Delete View[0];


// MPI output (Creates new views)
delta=2.0;
For k In {0:NP-1}
Merge Sprintf("./deltchk_2_10000000.0_0.03_45.0_0.0_%0.1f_5.0_50_100/p%010.0f.pos%.0f",delta,t0,k);
Merge Sprintf("./deltchk_2_10000000.0_0.03_45.0_0.0_%0.1f_5.0_50_100/p%010.0f.pos%.0f",delta,t1,k);
EndFor

View[0].TimeStep=t0;
// Save maximum and minimum pressures
Printf("%0.1f       %f,       %f", delta, View[0].Max, View[0].Min) >> fout;

Delete View[0];



// MPI output (Creates new views)
delta=10;
For k In {0:NP-1}
Merge Sprintf("./deltchk_2_10000000.0_0.03_45.0_0.0_10_5.0_50_100/p%010.0f.pos%.0f",t0,k);
Merge Sprintf("./deltchk_2_10000000.0_0.03_45.0_0.0_10_5.0_50_100/p%010.0f.pos%.0f",t1,k);
EndFor

paI = View[0].Max;//-0.714;
paR = View[0].Min;//+0.714;

View[0].TimeStep=t0;
// Save maximum and minimum pressures
Printf("%0.1f       %f,       %f", delta, paI, paR) >> fout;

Delete View[0];








// // View 3: dUdy
// Plugin(Gradient).View=0;
// Plugin(Gradient).Run; //Create View 3 Grad U
// Plugin(MathEval).Expression0 = "v1";
// Plugin(MathEval).View = 3;
// Plugin(MathEval).Run; //Creates View 4 dUdy
// Delete View[3]; // dUdy is now view 3

// // View 4: dVdx
// Plugin(Gradient).View=1;
// Plugin(Gradient).Run; //Create View 4 Grad V
// Plugin(MathEval).Expression0 = "v0";
// Plugin(MathEval).View = 4;
// Plugin(MathEval).Run; //Creates View 5 dVdx
// Delete View[4];
