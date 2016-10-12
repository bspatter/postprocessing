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
General.ScaleX = 10; //Currently squished aspect ratio 1/2, 40:40 is my other standard
General.ScaleY = 1.5;
General.TranslationX = -7.5;
General.TranslationY = -50;
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

t=0; t1 = 3; t2=6; t3=9; t4=12; t5=20; t6=25; t7=30;


For k In {0:NP-1}
Merge Sprintf("./p%010.0f.pos%.0f",t,k);
Merge Sprintf("./p%010.0f.pos%.0f",t1,k);
Merge Sprintf("./p%010.0f.pos%.0f",t2,k);
Merge Sprintf("./p%010.0f.pos%.0f",t3,k);
Merge Sprintf("./p%010.0f.pos%.0f",t4,k);
Merge Sprintf("./p%010.0f.pos%.0f",t5,k);
Merge Sprintf("./p%010.0f.pos%.0f",t6,k);
Merge Sprintf("./p%010.0f.pos%.0f",t7,k);
EndFor 

numtviews=PostProcessing.NbViews-1;

For k In {0:NP-1}
Merge Sprintf("./y0%010.0f.pos%.0f",t,k);
Merge Sprintf("./y0%010.0f.pos%.0f",t1,k);
Merge Sprintf("./y0%010.0f.pos%.0f",t2,k);
Merge Sprintf("./y0%010.0f.pos%.0f",t3,k);
Merge Sprintf("./y0%010.0f.pos%.0f",t4,k);
Merge Sprintf("./y0%010.0f.pos%.0f",t5,k);
Merge Sprintf("./y0%010.0f.pos%.0f",t6,k);
Merge Sprintf("./y0%010.0f.pos%.0f",t7,k);
EndFor 

// Assign values to the views
v0 = 0;

General.Clip0A = 0;
General.Clip0B = -1.0; 
General.Clip0C = 0;
General.Clip0D = 60.0; // YMax

General.Clip1A = 0;
General.Clip1B = 1;
General.Clip1C = 0;
General.Clip1D = 20; // -YMin


BoundingBox { 0, 1, -100, 1, 0, 0 };


//Offset of original view
xoff=0.00;

// Custom density
View[v0].Name = "Pressure";
View[v0].ScaleType = 1; 
View[v0].RangeType = 1; //1 = auto, 2 = custom, 3 = per time step
View[v0].CustomMax = -71;
View[v0].CustomMin = 71;
View[v0].SaturateValues = 1;
View[v0].Format = "%5.2f";
View[v0].NbIso = 3;
View[v0].ShowTime = 0;
View[v0].Color.Axes = Black;
View[v0].OffsetX = xoff;
View[v0].OffsetY = 0.0;
View[v0].AutoPosition = 1;
View[v0].PositionX = 1230;
View[v0].PositionY = -80;
View[v0].Width = 20;
View[v0].Height = 500;
View[v0].Axes = 2;
View[v0].AxesAutoPosition=1;
View[v0].AxesFormatY = "%0.1f";
//View[v0].AxesMaxY=1;
//View[v0].AxesMinY=-2;
View[v0].MinY=-5;
View[v0].MaxY=50;
View[v0].AxesTicsX = 2;
//View[v0].AxesTicsY = 7;
View[v0].ColormapNumber = 10;
View[v0].ColormapInvert = 1;
View[v0].ColormapSwap = 1;
View[v0].Clip = 1+2;
View[v0].Light = 0;
Include "redblue_diverging.map";
//Include "whiteblue.map";

Mesh.Clip = 1+2;



// //
// // Overlay mass fraction contours (derived from y0)
// //
View[1].IntervalsType = 1;
View[1].NbIso = 100;
View[1].RangeType = 3; 
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
Plugin(Annotate).FontSize = 10;
Plugin(Annotate).Align = "Center" ;
Plugin(Annotate).ThreeD=1; //Use model coordinates
Plugin(Annotate).X = 0.5; //By convention, for window coordinates a value greater than 99999 represents the center.
Plugin(Annotate).Y = -5.0 ;

//  //Will be redefined for each view
Plugin(Annotate).View = 0 ;
Plugin(Annotate).Text = Sprintf("t = %05.2f",t);
Plugin(Annotate).Run;
vt=PostProcessing.NbViews-1;
//View[vt].Color.Text2D = {255,255,255}; //White text
View[vt].Color.Text2D = {15,15,15};




// x offset for this view
xoff1=xoff+1.05;

AliasWithOptions View[0];
v0=PostProcessing.NbViews-1;
View[v0].TimeStep=t1;
View[v0].PositionY = 10000;
View[v0].OffsetX = xoff1;
View[v0].Axes=2;
View[v0].AxesTicsY=0;
View[v0].AxesTicsX=2;
View[v0].ShowScale=0;

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
View[v0].TimeStep=t2;
View[v0].PositionY = 10000;
View[v0].OffsetX = xoff2;
View[v0].Axes=2;
View[v0].AxesTicsY=0;
View[v0].AxesTicsX=2;
View[v0].ShowScale=0;
View[v0].ShowTime=1;


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
View[v0].TimeStep=t3;
View[v0].PositionY = 10000;
View[v0].OffsetX = xoff3;
View[v0].Axes=2;
View[v0].AxesTicsY=0;
View[v0].AxesTicsX=2;
View[v0].ShowScale=0;


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

// x offset for this view
xoff4=xoff+4.20;

AliasWithOptions View[0];
v0=PostProcessing.NbViews-1;
View[v0].TimeStep=t4;
View[v0].PositionY = 10000;
View[v0].OffsetX = xoff4;
View[v0].Axes=2;
View[v0].AxesTicsY=0;
View[v0].AxesTicsX=2;
View[v0].ShowScale=0;


AliasWithOptions View[1];
v1=PostProcessing.NbViews-1;
View[v1].TimeStep=t4;
View[v1].OffsetX = xoff4;

Plugin(Annotate).View = v1-1 ;
Plugin(Annotate).Text = Sprintf("t = %05.2f",t4);
Plugin(Annotate).X = 0.5+xoff4; //By convention, for window coordinates a value greater than 99999 represents the center.
Plugin(Annotate).Run;
vt=PostProcessing.NbViews-1;
View[vt].Color.Text2D = {15,15,15};


///////////////////////////////////////////////////////////////////////


// x offset for this view
xoff5=xoff+5.25;
AliasWithOptions View[0];
v0=PostProcessing.NbViews-1;
View[v0].TimeStep=t5;
View[v0].PositionY = 10000;
View[v0].OffsetX = xoff5;
View[v0].Axes=2;
View[v0].AxesTicsY=0;
View[v0].AxesTicsX=2;
View[v0].ShowScale=0;
View[v0].ShowTime=1;


AliasWithOptions View[1];
v1=PostProcessing.NbViews-1;
View[v1].TimeStep=t5;
View[v1].OffsetX = xoff5;

Plugin(Annotate).View = v1-1 ;
Plugin(Annotate).Text = Sprintf("t = %05.2f",t5);
Plugin(Annotate).X = 0.5+xoff5; //By convention, for window coordinates a value greater than 99999 represents the center.
Plugin(Annotate).Run;
vt=PostProcessing.NbViews-1;
View[vt].Color.Text2D = {15,15,15};

// ///////////////////////////////////////////////////////////////

// x offset for this view
xoff6=xoff+6.30;
AliasWithOptions View[0];
v0=PostProcessing.NbViews-1;
View[v0].TimeStep=t6;
View[v0].PositionY = 10000;
View[v0].OffsetX = xoff6;
View[v0].Axes=2;
View[v0].AxesTicsY=0;
View[v0].AxesTicsX=2;
View[v0].ShowScale=0;
View[v0].ShowTime=1;


AliasWithOptions View[1];
v1=PostProcessing.NbViews-1;
View[v1].TimeStep=t6;
View[v1].OffsetX = xoff6;

Plugin(Annotate).View = v1-1 ;
Plugin(Annotate).Text = Sprintf("t = %05.2f",t6);
Plugin(Annotate).X = 0.5+xoff6; //By convention, for window coordinates a value greater than 99999 represents the center.
Plugin(Annotate).Run;
vt=PostProcessing.NbViews-1;
View[vt].Color.Text2D = {15,15,15};

////////////////////////////////////////////////////////

// x offset for this view
xoff7=xoff+7.35;
AliasWithOptions View[0];
v0=PostProcessing.NbViews-1;
View[v0].TimeStep=t7;
View[v0].PositionY = 10000;
View[v0].OffsetX = xoff7;
View[v0].Axes=2;
View[v0].AxesTicsY=0;
View[v0].AxesTicsX=2;
View[v0].ShowScale=0;
View[v0].ShowTime=1;


AliasWithOptions View[1];
v1=PostProcessing.NbViews-1;
View[v1].TimeStep=t7;
View[v1].OffsetX = xoff7;

Plugin(Annotate).View = v1-1 ;
Plugin(Annotate).Text = Sprintf("t = %05.2f",t7);
Plugin(Annotate).X = 0.5+xoff7; //By convention, for window coordinates a value greater than 99999 represents the center.
Plugin(Annotate).Run;
vt=PostProcessing.NbViews-1;
View[vt].Color.Text2D = {15,15,15};


Sleep 0.0001;
Draw;
Print.Background = 1;



Print Sprintf("./pics_p/snapshots.jpg");
System "convert ./pics_p/snapshots.jpg -trim ./pics_p/snapshots.jpg";




//Delete View[3]
//Delete View[2];
//Delete View[1];
//Delete View[0];
