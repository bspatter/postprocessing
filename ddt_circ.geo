/* Output the circulation and the density weighted enstrophy to a file.*/

Merge "./mesh.msh";
Nt = 249+1;//249+1;
NP=6;


// Loop on time and output the values
fout = 'ddt_circ.dat';
Printf("Time,        dGdt_advective,    dGdt_compressible,    dGdt_baroclinic,    dGdt_total") > fout;


For t In {0:Nt-1}

// MPI output (Creates new views)
For k In {0:NP-1}
Merge Sprintf("./ux%010.0f.pos%.0f",t,k);
Merge Sprintf("./uy%010.0f.pos%.0f",t,k);
Merge Sprintf("./rho%010.0f.pos%.0f",t,k);
Merge Sprintf("./p%010.0f.pos%.0f",t,k);
EndFor 

// Assign label to loaded .pos file view
U = PostProcessing.NbViews-4;
V = PostProcessing.NbViews-3;
rho = PostProcessing.NbViews-2;
p = PostProcessing.NbViews-1;


// // Extract the right times, delete the old ones
Plugin(MathEval).Expression0 = "v0"; //Mathematical expression (numbers behind v0) v0,v1,v2 are convention within gmsh for the first, etc... values component in the field
Plugin(MathEval).View = U; //U label
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).Run; //This creates new View[4]
Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).View = V;
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).Run; //This creates new View[5]
Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).View = rho;
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).Run; //This creates new View[6]
Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).View = p;
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).Run; //This creates new View[7]


// Delete views in reverse order they were defined because deleting causes renumbering (renames views[2,3] from plugin to be Views[0,1]
Delete View[3]; //p
Delete View[2]; //rho
Delete View[1]; //V
Delete View[0]; //U

//////////////Calculate components of time derivative of vorticity /////////////////////

// Lengths of domain
Lx = View[U].MaxX-View[U].MinX;
Ly = View[U].MaxY-View[U].MinY;

// View 4: vector view for velocity
Plugin(Scal2Vec).NameNewView="U";
Plugin(Scal2Vec).ViewX=U;
Plugin(Scal2Vec).ViewY=V;
Plugin(Scal2Vec).Run;

// View 5: Take the curl of velocity = vorticity
Plugin(Curl).View = 4;
Plugin(Curl).Run;
View[5].Name = "Vorticity";

// View 6: Gradient of vorticity for advective term
Plugin(Gradient).View = 5; //Vorticity
Plugin(Gradient).Run;

// View 7: Advective contribution to vorticity generation (dw/dt)_advective
Plugin(MathEval).View = 6; //Gradient of vorticity
Plugin(MathEval).OtherView = 4; //U
Plugin(MathEval).Expression0 = "-(v0*w0+v1*w1)";
Plugin(MathEval).TimeStep = -1;
Plugin(MathEval).Run; //This creates new View[7], (dw/dt)_advective
View[7].Name = "(dw/dt)_advective";

// Delete Gradient of vorticity
Delete View[6]; //"(dw/dt)_advective" becomes View[6]

// View 7: Divergence of u for compressible term
Plugin(Divergence).View = 4; //U
Plugin(Divergence).Run;

// View 8: Compressible Vortex stretching contribution to vorticity generation (dw/dt)_compressible
Plugin(MathEval).View = 5; //Vorticity
Plugin(MathEval).OtherView = 7; //Divergence of velocity
Plugin(MathEval).Expression0 = "-(v0*w0)";
Plugin(MathEval).TimeStep = -1;
Plugin(MathEval).OtherTimeStep = -1;
Plugin(MathEval).Run; //This creates new View[8], (dw/dt)_compressible
View[8].Name = "(dw/dt)_compressible";

// Delete Gradient of vorticity
Delete View[7]; //"(dw/dt)_compressible" becomes View[7]

// View 8: Gradient of density for baroclinic term
Plugin(Gradient).View = 2;
Plugin(Gradient).Run; // Creates View 8, grad(rho)

// View 9: Gradient of pressure for baroclinic term
Plugin(Gradient).View = 3;
Plugin(Gradient).Run;// Creates View 9, grad(p)

// View 10: Numerator of baroclinic contribution to vorticity
Plugin(MathEval).View = 8; // grad(rho)
Plugin(MathEval).OtherView = 9; // grad(p)
Plugin(MathEval).Expression0 = "v0*w1-v1*w0";
Plugin(MathEval).TimeStep = -1;
Plugin(MathEval).OtherTimeStep = -1;
Plugin(MathEval).Run; //This creates new View[10], grad(rho) X grad(p)

// View 11: Baroclinic contribution to vorticity generation (dw/dt)_baroclinic
Plugin(MathEval).View = 10; // grad(rho) X grad(p)
Plugin(MathEval).OtherView = 2; // rho
Plugin(MathEval).Expression0 = "v0/w0^2";
Plugin(MathEval).TimeStep = -1;
Plugin(MathEval).OtherTimeStep = -1;
Plugin(MathEval).Run; //This creates new View[11], (dw/dt)_baroclinic
View[11].Name = "(dw/dt)_baroclinic";

// Delete Gradients of density, pressure and their cross product
Delete View[10];
Delete View[9];
Delete View[8]; //"(dw/dt)_baroclinic" becomes View[8]

// //Summary of current views
// // View[0-8] = [Ux, Uy, rho, p, vector(U), vorticity, (dw/dt)_advective, (dw/dt)_compressible, (dw/dt)_baroclinic]


////////Calculate components of time derivative of circulation by integrating //////////


// Delete Gradients of density, pressure and their cross product
Delete View[5]; // Vorticity
Delete View[4]; // vector(U)
Delete View[3]; // p
Delete View[2]; // rho
Delete View[1]; // Uy
Delete View[0]; // Ux


// //Summary of current views
// // View[0-2] = [(dw/dt)_advective, (dw/dt)_compressible, (dw/dt)_baroclinic]


// View 3: Get half the domain for (dw/dt)_advective
Plugin(CutPlane).View = 0;
Plugin(CutPlane).A =-1;
Plugin(CutPlane).B = 0;
Plugin(CutPlane).C = 0;
Plugin(CutPlane).D = Lx/2;
Plugin(CutPlane).ExtractVolume = 1;
Plugin(CutPlane).Run; // Creates View[3], half domain for (dw/dt)_advective

// View 4: Integrate (dw/dt)_advective to get (d/dt[circulation])_advective
Plugin(Integrate).View = 3;
Plugin(Integrate).Run; // Create View[4], (d/dt[circulation])_advective
View[4].Name = "(d/dt[circulation])_advective";

// Delete half domain for (dw/dt)_advective
Delete View[3]; //(d/dt[circulation])_advective becomes View[3]


// View 4: Get half the domain for (dw/dt)_compressible
Plugin(CutPlane).View = 1;
Plugin(CutPlane).A =-1;
Plugin(CutPlane).B = 0;
Plugin(CutPlane).C = 0;
Plugin(CutPlane).D = Lx/2;
Plugin(CutPlane).ExtractVolume = 1;
Plugin(CutPlane).Run; // Creates View[4], half domain for (dw/dt)_compressible

// View 5: Integrate (dw/dt)_advective to get (d/dt[circulation])_compressible
Plugin(Integrate).View = 4;
Plugin(Integrate).Run; // Create View[5], (d/dt[circulation])_compressible
View[5].Name = "(d/dt[circulation])_compressible";


// Delete half domain for (dw/dt)_advective
Delete View[4]; //(d/dt[circulation])_advective becomes View[4]

// View 5: Get half the domain for (dw/dt)_baroclinic
Plugin(CutPlane).View = 2;
Plugin(CutPlane).A =-1;
Plugin(CutPlane).B = 0;
Plugin(CutPlane).C = 0;
Plugin(CutPlane).D = Lx/2;
Plugin(CutPlane).ExtractVolume = 1;
Plugin(CutPlane).Run; // Creates View[5], half domain for (dw/dt)_baroclinic

// View 6: Integrate (dw/dt)_baroclinic to get (d/dt[circulation])_baroclinic
Plugin(Integrate).View = 5;
Plugin(Integrate).Run; // Create View[6], (d/dt[circulation])_baroclinic
View[6].Name = "(d/dt[circulation])_baroclinic";

// Delete half domain for (dw/dt)_advective
Delete View[5]; // (d/dt[circulation])_advective becomes View[5]


// //Summary of current views
// // View[0-5] = [(dw/dt)_advective, (dw/dt)_compressible, (dw/dt)_baroclinic, (d/dt[circulation])_advective, (d/dt[circulation])_compressible, (d/dt[circulation])_baroclinic]


// View 6: Calculate d/dt[circulation]_compressible + d/dt[circulation]_baroclinic (needed for d/dt[circulation]_total)
Plugin(MathEval).View = 4; // (d/dt[circulation])_compressible
Plugin(MathEval).OtherView = 5; // (d/dt[circulation])_baroclinic
Plugin(MathEval).Expression0 = "v0+w0";
Plugin(MathEval).TimeStep = -1;
Plugin(MathEval).Run; // Creates View[6], [ (d/dt[circulation])_compressible + (d/dt[circulation])_baroclinic ]

// View 7: Calculate d/dt[circulation]_total
Plugin(MathEval).View = 6; // (d/dt[circulation])_compressible + (d/dt[circulation])_baroclinic
Plugin(MathEval).OtherView = 3; // (d/dt[circulation])_advective
Plugin(MathEval).Expression0 = "v0+w0";
Plugin(MathEval).TimeStep = -1;
Plugin(MathEval).OtherTimeStep = -1;
Plugin(MathEval).Run; // Creates View[7], (d/dt[circulation])_total 
View[7].Name = "(d/dt[circulation])_total";

// Delete views that aren't to be printed: (dw/dt), etc...
Delete View[6]; // [ (d/dt[circulation])_compressible + (d/dt[circulation])_baroclinic ]
Delete View[2]; // (dw/dt)_baroclinic
Delete View[1]; // (dw/dt)_compressible
Delete View[0]; // (dw/dt)_advective

//Summary of current views
//View[0-3] = [(d/dt[circulation])_advective, (d/dt[circulation])_compressible, (d/dt[circulation])_baroclinic, (d/dt[circulation])_total ]


Printf("%f,    %e,      %e,         %e,      %e", t, View[0].Max, View[1].Max, View[2].Max, View[3].Max) >> fout;

// Delete remaining views
Delete View[3];
Delete View[2];
Delete View[1];
Delete View[0];


EndFor


// To read into matlab:
// dGdt = importdata('ddt_circ.dat', ',', 1);