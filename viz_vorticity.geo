//
// Load vorticity data (to be used by viz.geo)
// 
For k In {0:NP-1}
Merge Sprintf("./ux%010.0f.pos%.0f",num,k);
//Merge Sprintf("./ux%010.0f.pos",num);
EndFor 
For k In {0:NP-1}
Merge Sprintf("./uy%010.0f.pos%.0f",num,k);
//Merge Sprintf("./uy%010.0f.pos",num);
EndFor 

v0 = 0;

General.Clip0A = 0;
General.Clip0B = -1.0;
General.Clip0C = 0;
General.Clip0D = 1.0; 

General.Clip1A = 0;
General.Clip1B = 1;
General.Clip1C = 0;
General.Clip1D = 2; 


BoundingBox { -1, 1, -100, 1, 0, 0 };


Plugin(MathEval).Expression0 = "v0";
Plugin(MathEval).Expression1 = "w0";
Plugin(MathEval).TimeStep = num;
Plugin(MathEval).View = 0;
Plugin(MathEval).OtherTimeStep = num;
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

// Custom 
View[v0].Name = "Vorticity";
View[v0].ScaleType = 1; 
View[v0].RangeType = 3;
//View[v0].CustomMax =0.20;
//View[v0].CustomMin =-0.20;
View[v0].SaturateValues = 1;
//View[v0].Format = "%5.5g";
View[v0].NbIso = 4;
View[v0].ShowTime = 0;
View[v0].Color.Axes = Black;
View[v0].OffsetX = 0.0;
View[v0].OffsetY = 0.0;
View[v0].AutoPosition = 0;
View[v0].PositionX = 900;
View[v0].PositionY = 110;
View[v0].Width = 20;
View[v0].Height = 500;
View[v0].Axes = 1;
View[v0].AxesFormatY = "%0.1f";
View[v0].AxesAutoPosition=0;
View[v0].AxesMaxY=1.0;
View[v0].AxesMinY=-2;
View[v0].MinY=-10;
View[v0].MaxY=0;
View[v0].AxesTicsX = 2;
View[v0].AxesTicsY = 7;
View[v0].Clip = 1+2;
View[v0].Light = 0;
Include "map.map";

Mesh.Clip = 1+2;

// // Adapt visualization
// View[v0].AdaptVisualizationGrid = 1;
// View[v0].MaxRecursionLevel = 2;
// View[v0].TargetError = -1;

T = t*Dtout;

//Add a title
Plugin(Annotate).FontSize = 48;
Plugin(Annotate).Text = Sprintf("t = %5.2f",T);
Plugin(Annotate).X = 630; // By convention, for window coordinates a value greater than 99999 represents the center.
Plugin(Annotate).Y = 150 ;
Plugin(Annotate).Align = "Left" ;
Plugin(Annotate).View = 0 ;
Plugin(Annotate).Run ;
//View[0].Color.Text2D = {255,255,255};
View[0].Color.Text2D = {15,15,15};

// //
// // Overlay mass fraction contours (derived from y0)
// //
// // View 1: load pinf
For k In {0:NP-1}
Merge Sprintf("./y0%010.0f.pos%.0f",num,k);
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
Print Sprintf("./pics_vorticity/rmaw_vorticity%03g.jpg", num);

Delete View[1];
Delete View[0];
