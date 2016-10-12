//
// Similar to rhoviz2 but this one cuts the domain to the size we
// want. It also changes the way the schlieren is calculated.
//

Merge "./mesh.msh";
t = 0;
Nt = 1000+1;
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
General.TranslationX = -0.5;
General.TranslationY = -0.75;
General.GraphicsWidth = 2400 ;
General.GraphicsHeight = 1280 ;
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

// Loop on time
For num In {0:Nt-1}

// Include the load files
Include "viz_rho.geo";
//Include "viz_rho_mach.geo";
//Include "viz_ux.geo";
//Include "viz_umag.geo";
//Include "viz_mach.geo";
//Include "viz_p.geo";
//Include "viz_vorticity.geo";
//Include "viz_sch.geo";
//Include "viz_T.geo";

t = t+1;
EndFor

//Exit;
//System "mencoder mf://pics/*.jpg -mf fps=10:type=jpg -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell -oac copy -o output.avi";
//System "avconv -i output.avi -vcodec mpeg4 -b:v 1200k -flags +aic+mv4 output.mp4"; // from http://andrebluehs.net/blog/2012/05/converting-avi-to-mp4-with-ffmpeg/
