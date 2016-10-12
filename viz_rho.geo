//
// Load density data (to be used by viz.geo)
// 

For k In {0:NP-1}
Merge Sprintf("./rho%010.0f.pos%.0f",num,k);
EndFor 

// Assign values to the views
v0 = PostProcessing.NbViews-1;

General.Clip0A = 0;
General.Clip0B = -1.0;
General.Clip0C = 0;
General.Clip0D = 1.0; 

General.Clip1A = 0;
General.Clip1B = 1;
General.Clip1C = 0;
General.Clip1D = 2; 


BoundingBox { -1, 1, -100, 1, 0, 0 };

// Custom density
View[v0].Name = "Density";
View[v0].ScaleType = 2; 
View[v0].RangeType = 2;
View[v0].CustomMax = 1000;
View[v0].CustomMin = 0.1;
View[v0].SaturateValues = 1;
View[v0].Format = "%5.2f";
View[v0].NbIso = 4;
View[v0].ShowTime = 0;
View[v0].Color.Axes = Black;
View[v0].OffsetX = 0.0;
View[v0].OffsetY = 0.0;
View[v0].AutoPosition = 0;
View[v0].PositionX = 925;
View[v0].PositionY = 110;
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
//Include "map.map";
Include "whiteblue.map";

Mesh.Clip = 1+2;

// // Adapt visualization
// View[v0].AdaptVisualizationGrid = 1;
// View[v0].MaxRecursionLevel = 2;
// View[v0].TargetError = -1;

T = t*Dtout;

// Add a title
Plugin(Annotate).Text = Sprintf("t = %5.2f",T);
Plugin(Annotate).X = 750; // By convention, for window coordinates a value greater than 99999 represents the center.
Plugin(Annotate).Y = 150 ;
Plugin(Annotate).FontSize = 48;
Plugin(Annotate).Align = "Center" ;
Plugin(Annotate).View = 0 ;
Plugin(Annotate).Run ;
//View[1].Color.Text2D = {255,255,255};
View[1].Color.Text2D = {15,15,15};


// //
// // Overlay mass fraction contours (derived from y0)
// //
// // View 1: load pinf
For k In {0:NP-1}
Merge Sprintf("./y0%010.0f.pos%.0f",num,k);
EndFor

View[2].IntervalsType = 1;
View[2].NbIso = 100;
View[2].RangeType = 2;
View[2].CustomMax = 0.52;
View[2].CustomMin = 0.48;
View[2].SaturateValues = 1;
View[2].ShowScale = 0;
View[2].LineWidth = 1;
View[2].Light = 0;
View[2].ColorTable = {{0,0,0,255}};//{{255, 255, 255,255}};//{{238, 46, 47,255}};


Sleep 0.0001;
Draw;
Print.Background = 1;

Print Sprintf("./pics_rho/rmaw%05g.jpg", num);



Delete View[2];
Delete View[1];
Delete View[0];
