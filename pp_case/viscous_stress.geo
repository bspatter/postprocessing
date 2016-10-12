/* Output the circulation and the density weighted enstrophy to a file.*/

//Merge "./mesh.msh";
//Nt = 2;// 199+1;
//NP=1;


// Loop on time and output the values
fout = 'tau_xy_max.dat';
Printf("# Viscous Shear Stress") > fout;
Printf("") >> fout;

For t In {0:Nt-1}

// MPI output (Creates new views)
If (NP > 1)
For k In {0:NP-1}
Merge Sprintf("./ux%010.0f.pos%.0f",t,k);
Merge Sprintf("./uy%010.0f.pos%.0f",t,k);
Merge Sprintf("./y0%010.0f.pos%.0f",t,k);
EndFor
Else
For k In {0:NP-1}
Merge Sprintf("./ux%010.0f.pos",t);
Merge Sprintf("./uy%010.0f.pos",t);
Merge Sprintf("./y0%010.0f.pos",t);
EndFor
EndIf


// Assign label to loaded .pos file view
v0 = PostProcessing.NbViews-3;
v1 = PostProcessing.NbViews-2;
v2 = PostProcessing.NbViews-1;

// Extract the right times, delete the old ones
Plugin(MathEval).Expression0 = "v0"; //Mathematical expression (numbers behind v0) v0,v1,v2 are convention within gmsh for the first, etc... values component in the field
Plugin(MathEval).View = v0; //v0 label
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).OtherView = v0; //v0 label
Plugin(MathEval).OtherTimeStep = t;
Plugin(MathEval).Run; //This creates new View[3]
//
Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).View = v1;
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).Run; //This creates new View[4]
//
Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).View = v2;
Plugin(MathEval).TimeStep = t;
Plugin(MathEval).Run; //This creates new View[5]

// Delete views in reverse order because deleting causes renumbering (renames views[2,3] from plugin to be Views[0,1]
Delete View[2];
Delete View[1];
Delete View[0];

// Lengths of domain
Lx = View[0].MaxX-View[0].MinX;
Ly = View[0].MaxY-View[0].MinY;


// View 3: dUdy + dVdX
Plugin(Gradient).View=0;
Plugin(Gradient).Run; //Create View 3 Grad U
Plugin(Gradient).View=1;
Plugin(Gradient).Run; //Create View 4 Grad V

Plugin(MathEval).Expression0 = "v1+w0";
Plugin(MathEval).View = 3;
Plugin(MathEval).OtherView=4;
Plugin(MathEval).TimeStep = 0;//t;
Plugin(MathEval).OtherTimeStep = 0;//t;
Plugin(MathEval).Run; //Creates View 4 dUdy
Delete View[4];
Delete View[3]; // dUdy+dVdx is now view 3


//Shear Stress
// // muw=0.0005926051848703781; //mua=0.0004790960093539129;
Plugin(MathEval).Expression0 = "(0.0005926051848703781*v0+(1-v0)*0.0004790960093539129)*w0";
Plugin(MathEval).View = 2;
Plugin(MathEval).OtherView = 3;
Plugin(MathEval).TimeStep = 0;//t;
Plugin(MathEval).OtherTimeStep = 0;//t;
Plugin(MathEval).Run; //This creates new View[4]


// Save .txt file (commented out because these files are huge)
//Save View[4] Sprintf("./tau_xy_%010.0f.txt",t);

// Save maximum shear stress
Printf("%05.0f %e",t,View[4].Max) >> fout;

Delete View[4];
Delete View[3];
Delete View[2];
Delete View[1];
Delete View[0];


EndFor



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
