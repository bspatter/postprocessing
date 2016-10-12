//
// Similar to rhoviz2 but this one cuts the domain to the size we
// want. It also changes the way the schlieren is calculated.
//

Merge "./mesh.msh";
t = 0;
Nt = 0+1;
Dtout = 0.1;
NP=6;

General.Color.Background = White ;
General.Color.Foreground = Black ;
General.Color.Text = Black ;
General.BackgroundGradient = 0;
General.SmallAxes = 0;
General.Trackball = 0 ;
General.RotationX = 0;
General.RotationY = 0;
General.RotationZ = 0;
General.ScaleX = 40;
General.ScaleY = 40;
General.TranslationX = -2.5;
General.TranslationY = -0.6;
General.GraphicsWidth = 1680 ;
General.GraphicsHeight = 1050 ;
General.GraphicsFont="Times-Roman";
General.GraphicsFontTitle="Times-Roman";
General.GraphicsFontSize = 24;
General.GraphicsFontSizeTitle = 24;
General.Axes=0;

Geometry.Points = 0;

Mesh.Lines = 0;
Mesh.LineWidth = 2;
Mesh.Triangles = 1;
Mesh.SurfaceEdges=0;
Mesh.SurfaceFaces=0;
Mesh.ColorCarousel = 0; //Mesh coloring (0=by element type, 1=by elementary entity, 2=by physical entity, 3=by partition)

PostProcessing.HorizontalScales=0;

/////////////////////////////////////////////////////////////////////////
/////////////////// Out OF viz.geo portion of script ////////////////////
//
// Load density data (to be used by viz.geo)
// 

t = 0; t1 = 10; t2 = 100; t3=300;

// // RHO
// For k In {0:NP-1}
// Merge Sprintf("./rho%010.0f.pos%.0f",t,k);
// Merge Sprintf("./rho%010.0f.pos%.0f",t1,k);
// Merge Sprintf("./rho%010.0f.pos%.0f",t2,k);
// Merge Sprintf("./rho%010.0f.pos%.0f",t3,k);
// EndFor 


For k In {0:NP-1}
Merge Sprintf("./ux%010.0f.pos%.0f",t,k);
Merge Sprintf("./ux%010.0f.pos%.0f",t1,k);
Merge Sprintf("./ux%010.0f.pos%.0f",t2,k);
Merge Sprintf("./ux%010.0f.pos%.0f",t3,k);
EndFor 

For k In {0:NP-1}
Merge Sprintf("./uy%010.0f.pos%.0f",t,k);
Merge Sprintf("./uy%010.0f.pos%.0f",t1,k);
Merge Sprintf("./uy%010.0f.pos%.0f",t2,k);
Merge Sprintf("./uy%010.0f.pos%.0f",t3,k);
EndFor 


// VORTICITY
Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).Expression1 = "w0";
Plugin(MathEval).TimeStep = -1;
Plugin(MathEval).View = 0;
Plugin(MathEval).OtherTimeStep = -1;
Plugin(MathEval).OtherView = 1;
Plugin(MathEval).Run;

Delete View[1];
Delete View[0]; // View 2 is now view 0

// View 1: take the curl of velocity
Plugin(Curl).View = 0;
Plugin(Curl).Run;
Delete View[0]; // View 1 is now view 0

// View 1: take the 3d component of vorticity
Plugin(MathEval).Expression0 = "v2";
Plugin(MathEval).Expression1 = "";
Plugin(MathEval).TimeStep = -1;
Plugin(MathEval).View = 0;
Plugin(MathEval).OtherTimeStep = -1;
Plugin(MathEval).OtherView = -1;
Plugin(MathEval).Run;
Delete View[0]; // View 1 is now view 0




numtviews=PostProcessing.NbViews-1;
For k In {0:NP-1}
Merge Sprintf("./y0%010.0f.pos%.0f",t,k);
Merge Sprintf("./y0%010.0f.pos%.0f",t1,k);
Merge Sprintf("./y0%010.0f.pos%.0f",t2,k);
Merge Sprintf("./y0%010.0f.pos%.0f",t3,k);
EndFor 


















// SETUP THE SNAPSHOTS


// Assign values to the views
v0 = 0;

General.Clip0A = 0;
General.Clip0B = -1.0;
General.Clip0C = 0;
General.Clip0D = 1.0; 

General.Clip1A = 0;
General.Clip1B = 1;
General.Clip1C = 0;
General.Clip1D = 2; 


BoundingBox { 0, 1, -100, 1, 0, 0 };


//Offset of original view
xoff=0.00;
 
// Custom density
//View[v0].Name = "Density";
View[v0].Name="Vorticity";
View[v0].ScaleType = 1; 
View[v0].RangeType = 3; //2 for Rho
View[v0].CustomMax = 0.3; //1000 for Rho
View[v0].CustomMin = -0.3; // 1 for Rho
View[v0].SaturateValues = 1;
View[v0].Format = "";//"%5.2f";
View[v0].NbIso = 3;
View[v0].ShowTime = 0;
View[v0].Color.Axes = Black;
View[v0].OffsetX = xoff;
View[v0].OffsetY = 0.0;
View[v0].AutoPosition = 0;
View[v0].PositionX = 1230;
View[v0].PositionY = 80;
View[v0].Width = 20;
View[v0].Height = 500;
View[v0].Axes = 1;
View[v0].AxesAutoPosition=0;
View[v0].AxesFormatY = "%0.1f";
View[v0].AxesMaxY=1;
View[v0].AxesMinY=-2;
View[v0].MinY=-10;
View[v0].MaxY=0;
View[v0].AxesTicsX = 2;
View[v0].AxesTicsY = 7;
View[v0].ColormapNumber = 10;
View[v0].ColormapInvert = 0;
View[v0].ColormapSwap = 1;
View[v0].Clip = 1+2;
View[v0].Light = 0;
Include "redblue.map";

Mesh.Clip = 1+2;



// //
// // Overlay mass fraction contours (derived from y0)
// //
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
View[1].OffsetX=xoff;

// //
// Add a time-stamp
// //
Plugin(Annotate).Font = "Times-Roman";
Plugin(Annotate).FontSize = 32;
Plugin(Annotate).Align = "Center" ;
Plugin(Annotate).ThreeD=1; //Use model coordinates
Plugin(Annotate).X = 0.5; //By convention, for window coordinates a value greater than 99999 represents the center.
Plugin(Annotate).Y = -1.95 ;

////Will be redefined for each view
Plugin(Annotate).View = 0 ;
Plugin(Annotate).Text = Sprintf("t = %05.2f",0);
Plugin(Annotate).Run;
vt=PostProcessing.NbViews-1;
//View[vt].Color.Text2D = {255,255,255}; //White text
View[vt].Color.Text2D = {15,15,15};



// x offset for this view
xoff1=xoff+1.05;

AliasWithOptions View[0];
v0=PostProcessing.NbViews-1;
View[v0].TimeStep=1;//t1;
View[v0].PositionY = 10000;
View[v0].OffsetX = xoff1;


AliasWithOptions View[1];
v1=PostProcessing.NbViews-1;
View[v1].TimeStep=t1;
View[v1].OffsetX = xoff1;


Plugin(Annotate).View = v1-1 ;
Plugin(Annotate).Text = Sprintf("t = %05.2f",t1);
Plugin(Annotate).X = 0.5+xoff1; //By convention, for window coordinates a value greater than 99999 represents the center.
Plugin(Annotate).Run;
vt=PostProcessing.NbViews-1;
View[vt].Color.Text2D = {15,15,15};


////////////////////////////////////////////////////////////

// x offset for this view
xoff2=xoff+2.10;
AliasWithOptions View[0];
v0=PostProcessing.NbViews-1;
View[v0].TimeStep=2;//t2;
View[v0].PositionY = 10000;
View[v0].OffsetX = xoff2;


AliasWithOptions View[1];
v1=PostProcessing.NbViews-1;
View[v1].TimeStep=t2;
View[v1].OffsetX = xoff2;

Plugin(Annotate).View = v1-1 ;
Plugin(Annotate).Text = Sprintf("t = %05.2f",t2);
Plugin(Annotate).X = 0.5+xoff2; //By convention, for window coordinates a value greater than 99999 represents the center.
Plugin(Annotate).Run;
vt=PostProcessing.NbViews-1;
View[vt].Color.Text2D = {15,15,15};

// // ///////////////////////////////////////////////////////////

// x offset for this view
xoff3=xoff+3.15;

AliasWithOptions View[0];
v0=PostProcessing.NbViews-1;
View[v0].TimeStep=3;//t3;
View[v0].PositionY = 10000;
View[v0].OffsetX = xoff3;


AliasWithOptions View[1];
v1=PostProcessing.NbViews-1;
View[v1].TimeStep=t3;
View[v1].OffsetX = xoff3;

Plugin(Annotate).View = v1-1 ;
Plugin(Annotate).Text = Sprintf("t = %05.2f",t3);
Plugin(Annotate).X = 0.5+xoff3; //By convention, for window coordinates a value greater than 99999 represents the center.
Plugin(Annotate).Run;
vt=PostProcessing.NbViews-1;
View[vt].Color.Text2D = {15,15,15};

////////////////////////////////////////////////////////////








Sleep 0.0001;
Draw;
Print.Background = 1;

//Print Sprintf("./pics_rho/snapshots.jpg");
Print Sprintf("./pics_vorticity/snapshots.jpg");




