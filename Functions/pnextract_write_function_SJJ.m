function [] = pnextract_write_function_SJJ(image_name, pnextract_file,folder, MSS,minRPore, image_dim, voxel_size)

fid =fopen([folder, '/', pnextract_file],'w');

fprintf(fid, '%s\r\n',   'ObjectType =  Image');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'NDims =       3');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'ElementType = MET_UCHAR');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   ['DimSize = ', int2str(image_dim(1)), ' ',int2str(image_dim(2)), ' ', int2str(image_dim(3))]);
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   ['ElementSpacing = ', int2str(voxel_size), ' ',int2str(voxel_size), ' ', int2str(voxel_size)]);
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   ['Offset = ', int2str(0), ' ',int2str(0), ' ', int2str(0)]);
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   ['ElementDataFile = ', image_name]);
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   'DefaultImageFormat = .raw.gz');
fprintf(fid, '%s\r\n',   '');
fprintf(fid, '%s\r\n',   ['minRPore =  ', num2str(minRPore)]);
fprintf(fid, '%s\r\n',   '');
%fprintf(fid, '%s\r\n',   ['medialSurfaceSettings =  ', num2str(MSS(1)),' ',num2str(MSS(2)),' ',num2str(MSS(3)),' ',...
                                                      % num2str(MSS(4)),' ',num2str(MSS(5)),' ',num2str(MSS(6)),' ',...
                                                      % num2str(MSS(7)),' ',num2str(MSS(8)),' ',num2str(MSS(9))]);

fclose(fid);
end
