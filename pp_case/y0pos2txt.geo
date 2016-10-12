// Used by pos2txt.sh
// Converts the .pos field data to a ascii .txt file
//

//Merge "./mesh.msh";
//Nt = 1000;
//NP=6;

// Loop on time
For t In {0:Nt-1}

// MPI output (or not)
If (NP == 1)
Merge Sprintf("y0%010.0f.pos",t);
Else 
For k In {0:NP-1}
Merge Sprintf("y0%010.0f.pos%.0f",t,k);
EndFor
EndIf

View[0].Axes = 2;
View[0].Color.Axes = Black;
View[0].Type = 2;
View[0].IntervalsType= 2 ; 
View[0].RangeType = 2;
View[0].CustomMax = 1; 
View[0].CustomMin = 0; 
View[0].LineWidth=2;
View[0].AutoPosition = 0;
View[0].Width = 400;
View[0].Height = 260;
View[0].AxesTicsX = 11;
View[0].AxesFormatX = "%.1f";
View[0].AxesTicsY = 10;
View[0].SaturateValues = 1;
View[0].AdaptVisualizationGrid = 1;
View[0].MaxRecursionLevel = 1;
View[0].TargetError=-1;

Save View[0] Sprintf("./y0%010.0f.txt",t);
Delete View[0];

EndFor


Exit;
