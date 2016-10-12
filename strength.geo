// Extract the growth factors based on the mass fractions

Merge "./mesh.msh";
Nt = 500;

// Get the isosurface 
ylevel = 0.5;
yleveltop = 0.75;
ylevelbot = 0.25;

NP = 6; // number of processors
Nx= 100; // number of vertical cuts
L=1; // length of domain
dx=L/(Nx-1);     // cuts spaced by dx

// Output file
fout = 'strength075025_res100_cuts100_Brandon.dat';
Printf("%f %f %f %f",Nt,Nx,dx,L) > fout;

// Loop over time to write to file
For t In {0:Nt-1}

For k In {0:NP-1}

Merge Sprintf("./y0%010.0f.pos%.0f",t,k);
Merge Sprintf("./ux%010.0f.pos%.0f",t,k);
Merge Sprintf("./uy%010.0f.pos%.0f",t,k);

//Merge Sprintf("./y0%010.0f.pos",t);
//Merge Sprintf("./ux%010.0f.pos",t);
//Merge Sprintf("./uy%010.0f.pos",t);
EndFor

Y  = PostProcessing.NbViews-3;
UX = PostProcessing.NbViews-2;
UY = PostProcessing.NbViews-1;


// Loop over the number of cuts
For k In {0:Nx-1}

// Make a vertical cut in the domain
Printf("Make a cut at the plane x = %f",k*dx);
Plugin(CutPlane).A = 1 ;
Plugin(CutPlane).B = 0 ;
Plugin(CutPlane).C = 0 ;
Plugin(CutPlane).D = -k*dx;
Plugin(CutPlane).View = Y;             // source view
Plugin(CutPlane).Run ;                  // run the plugin!


// Extract the portion more than ylevel
Plugin(Isosurface).Value = ylevel ; // iso-value level
Plugin(Isosurface).ExtractVolume = 1;     // get everything above the iso-value
Plugin(Isosurface).View = Y+3;           // source view
Plugin(Isosurface).Run ;                  // run the plugin!

// Extract the portion more than yleveltop 
Plugin(Isosurface).Value = yleveltop ; // iso-value level
Plugin(Isosurface).ExtractVolume = 1;     // get everything above the iso-value
Plugin(Isosurface).View = Y+3;           // source view
Plugin(Isosurface).Run ;                  // run the plugin!

// Extract the portion more than ylevelbot 
Plugin(Isosurface).Value = ylevelbot ; // iso-value level
Plugin(Isosurface).ExtractVolume = 1;     // get everything above the iso-value
Plugin(Isosurface).View = Y+3;           // source view
Plugin(Isosurface).Run ;                  // run the plugin!


yvalue = View[Y+4].MinY;
yvaluetop = View[Y+5].MinY;
yvaluebot = View[Y+6].MinY;

// Get the top x-velocity 
Plugin(Probe).X = k*dx;
Plugin(Probe).Y = yvaluetop;
Plugin(Probe).Z = 0;
Plugin(Probe).View = UX;
Plugin(Probe).Run;

// Get the top y-velocity 
Plugin(Probe).X = k*dx;
Plugin(Probe).Y = yvaluetop;
Plugin(Probe).Z = 0;
Plugin(Probe).View = UY;
Plugin(Probe).Run;

// Get the bottom x-velocity 
Plugin(Probe).X = k*dx;
Plugin(Probe).Y = yvaluebot;
Plugin(Probe).Z = 0;
Plugin(Probe).View = UX;
Plugin(Probe).Run;

// Get the bottom y-velocity 
Plugin(Probe).X = k*dx;
Plugin(Probe).Y = yvaluebot;
Plugin(Probe).Z = 0;
Plugin(Probe).View = UY;
Plugin(Probe).Run;

//Take only the time steps we are interested in. For some reasons, 'Probe' adds empty time steps for which the solution is zero. Therefore, when we extract the data, it takes the //minimum between zero and the value. When the value is negative, it's fine because it takes the actual value, but when it's positive it's gonna extract zero instead of th//e actuaal value.
Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).View = 7;
Plugin(MathEval).Run;

Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).View = 8;
Plugin(MathEval).Run;

Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).View = 9;
Plugin(MathEval).Run;

Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).View = 10;
Plugin(MathEval).Run;

// Delete the probe values, which are replaced by the MathEval values
Delete View[10]; // delete the Probe bottom-y view
Delete View[9]; // delete the Probe bottom-x view
Delete View[8]; // delete the Probe top-y view
Delete View[7]; // delete the Probe top-x view


Printf("%e, %e, %e, %e, %e, %e, %e, %e, %e",t,k*dx,yvalue,yvaluetop,yvaluebot,View[7].Min,View[8].Min,View[9].Min,View[10].Min) >> fout;

Delete View[10]; // delete the Probe bottom-y view
Delete View[9]; // delete the Probe bottom-x view
Delete View[8]; // delete the Probe top-y view
Delete View[7]; // delete the Probe top-x view
Delete View[6]; // delete the isosurface bottom view
Delete View[5]; // delete the isosurface top view
Delete View[4]; // delete the isosurface view
Delete View[3]; // delete the cut view

EndFor

Delete View[UY];
Delete View[UX];
Delete View[Y];

EndFor
