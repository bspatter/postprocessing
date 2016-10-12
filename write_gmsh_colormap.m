function write_gmsh_colormap(file,mycolormap);
%This function converts a matlab style colormap 'mycolormap' into a gmsh colormap and saves it to file 

% Open file
fid=fopen(file,'w');

% Write colormap
[n,~]=size(mycolormap);
fprintf(fid,'View[v0].ColorTable = \n{');
for i=1:n-1
    fprintf(fid,'  {%u, %u, %u, %u},\n', round(255*mycolormap(i,:)),255);
end
fprintf(fid,'  {%u, %u, %u, %u}};', round(255*mycolormap(n,:)), 255);
fclose(fid);