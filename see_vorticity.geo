/* Output the circulation and the density weighted enstrophy to a file.*/

Merge "./mesh.msh";
//Nt = 1000+1;
NP=6;


// Loop on time and output the values
fout = 'circ.dat';
Printf("# Circulation") > fout;
Printf("") >> fout;

//For t In {0:Nt-1}

t=10;

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

Delete View[2];
Delete View[1];
Delete View[0];


// Custom 
View[0].Name = "Vorticity";
View[0].ScaleType = 1; 
View[0].RangeType = 3;
View[0].MinY=-5;
View[0].MaxY=0;


// //View[0].CustomMax =0.20;
// //View[0].CustomMin =-0.20;
// View[0].SaturateValues = 1;
// //View[0].Format = "%5.5g";
// View[0].NbIso = 4;
// View[0].ShowTime = 0;
// View[0].Color.Axes = Black;
// View[0].OffsetX = 0.0;
// View[0].OffsetY = 0.0;
// View[0].AutoPosition = 0;
// View[0].PositionX = 900;
// View[0].PositionY = 110;
// View[0].Width = 20;
// View[0].Height = 500;
// View[0].Axes = 1;
// View[0].AxesFormatY = "%0.1f";
// View[0].AxesAutoPosition=0;
// View[0].AxesMaxY=1.0;
// View[0].AxesMinY=-2;
// //View[0].AxesTicsX = 2;
// //View[0].AxesTicsY = 7;
// //View[0].Clip = 1+2;
// View[0].Light = 0;
Include "map.map";


// //
// // Overlay mass fraction contours (derived from y0)
// //
// // View 1: load pinf
For k In {0:NP-1}
Merge Sprintf("./y0%010.0f.pos%.0f",t,k);
EndFor

View[1].IntervalsType = 1;
View[1].NbIso = 100;
View[1].RangeType = 2;
View[1].CustomMax = 0.52;
View[1].CustomMin = 0.48;
View[1].SaturateValues = 1;
View[1].ShowScale = 0;
View[1].LineWidth = 1;
View[1].Light = 0;
View[1].ColorTable = {{0,0,0,255}};//{{255, 255, 255,255}};//{{238, 46, 47,255}};

Sleep 0.0001;
Draw;
Print.Background = 1;



