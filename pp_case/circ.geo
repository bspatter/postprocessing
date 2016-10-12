// CALLED BY pp_case.geo
/* Output the circulation and the density weighted enstrophy to a file.*/


// Loop on time and output the values
fout = 'circ.dat';
Printf("# Circulation") > fout;
Printf("") >> fout;

For t In {0:Nt-1}

// MPI output (Creates new views)
For k In {0:NP-1}
Merge Sprintf("./ux%010.0f.pos%.0f",t,k);
Merge Sprintf("./uy%010.0f.pos%.0f",t,k);
EndFor 

// Assign label to loaded .pos file view
v0 = PostProcessing.NbViews-2;
v1 = PostProcessing.NbViews-1;

// Extract the right times, delete the old ones
Plugin(MathEval).Expression0 = "v0"; //Mathematical expression (numbers behind v0) v0,v1,v2 are convention within gmsh for the first, etc... values component in the field
Plugin(MathEval).View = v0; //v0 label
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).Run; //This creates new View[2]
Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).View = v1;
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).Run; //This creates new View[2]

// // Delete views in reverse order because deleting causes renumbering (renames views[2,3] from plugin to be Views[0,1]
Delete View[v1];
Delete View[v0];

// Lengths of domain
Lx = View[v0].MaxX-View[v0].MinX;
Ly = View[v0].MaxY-View[v0].MinY;

// View 2: vector view for velocity
Plugin(Scal2Vec).NameNewView="U";
Plugin(Scal2Vec).ViewX=v0;
Plugin(Scal2Vec).ViewY=v1;
Plugin(Scal2Vec).Run;

// View 3: Take the curl of velocity = vorticity
Plugin(Curl).View = 2;
Plugin(Curl).Run;

// View 4: Get the z-dimension of the curl
Plugin(MathEval).View = 3;
Plugin(MathEval).Expression0 = "v2";
Plugin(MathEval).OtherView = -1;
Plugin(MathEval).TimeStep = -1;
Plugin(MathEval).Run;

// Delete vorticity vector
Delete View[3]; // vorticity-z becomes View[3]

// View 4: Get half the domain for vorticity
Plugin(CutPlane).A =-1;
Plugin(CutPlane).B = 0;
Plugin(CutPlane).C = 0;
Plugin(CutPlane).D = Lx/2;
Plugin(CutPlane).ExtractVolume = 1;
Plugin(CutPlane).View = 3;
Plugin(CutPlane).Run;

// View 5: Integrate vorticity to get circulation
Plugin(Integrate).View = 4;
Plugin(Integrate).Run;

// View 6: Extract number circulation view
Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).View = 5;
Plugin(MathEval).OtherView = -1;
Plugin(MathEval).TimeStep = -1;
Plugin(MathEval).Run;

Printf("%f	 %e",t,View[6].Max) >> fout;

Delete View[6];
Delete View[5];
Delete View[4];
Delete View[3];
Delete View[2];
Delete View[1];
Delete View[0];

EndFor
