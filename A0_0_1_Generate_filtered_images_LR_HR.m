clc
clearvars
close all

%Code to filter LR and HR images. 
%Change path below to respective image and save paths for files. 
image_path = 'Raw_images/Final_raw_8bit_normalised_tif_LR_HR_SR/';
save_path = 'Filtered_images/';

name = 'Core1_Subvol1';
tic
for kkk = 1

image_dim =  [225 225 225];
voxel_size = 6;

AA = Tiff([image_path,name, '_LR.tif'], 'r');
image_dummy = [];
for i =1:image_dim(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim(3))
        nextDirectory(AA)
    end
    
end

LR_image = double(image_dummy);


image_dim2 =  [675 675 675];
voxel_size2 = 2;

AA = Tiff([image_path,name, '_HR.tif'], 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
end
HR_image = double(image_dummy);

HR_image_filt_m = zeros(size(HR_image));
LR_image_filt_m = zeros(size(LR_image));

search_size = 11;
window_size = 5;
smoothing_lvl = 4.5;

for i =1:image_dim(3)
LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

LR_image_filt_8bit =  uint8(LR_image_filt_m);
LR_image_filt_bicubic_8bit = uint8(imresize3(LR_image_filt_m,3));

search_size = 11*3;
window_size = 5*3;
smoothing_lvl = 23.5;

for i = 1:image_dim2(3) 
HR_image_filt_m(:,:,i) = imnlmfilt(HR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

HR_image_filt_8bit =  uint8(HR_image_filt_m);

for i =1:image_dim(3)
   if (i > 1)
        imwrite(LR_image_filt_8bit(:,:,i),[save_path, name, '_LR_filtered.tif'],'WriteMode','append')
   else
       imwrite(LR_image_filt_8bit(:,:,i),[save_path,name, '_LR_filtered.tif'])
   end
end

for i =1:image_dim2(3)
   if (i > 1)
        imwrite(LR_image_filt_bicubic_8bit(:,:,i),[save_path,name, '_LR_bicubic_filtered.tif'],'WriteMode','append')
   else
       imwrite(LR_image_filt_bicubic_8bit(:,:,i),[save_path,name, '_LR_bicubic_filtered.tif'])
   end
end

for i =1:image_dim2(3)
   if (i > 1)
        imwrite(HR_image_filt_8bit(:,:,i),[save_path,name, '_HR_filtered.tif'],'WriteMode','append')
   else
       imwrite(HR_image_filt_8bit(:,:,i),[save_path,name, '_HR_filtered.tif'])
   end
end
end
toc
%%

clc
clearvars
close all

name = 'Core1_Subvol2';
tic
for kkk = 1

image_dim =  [225 225 225];
voxel_size = 6;

AA = Tiff([name, '_LR.tif'], 'r');
image_dummy = [];
for i =1:image_dim(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim(3))
        nextDirectory(AA)
    end
    
end

LR_image = double(image_dummy);

image_vec{1} = LR_image(:);


image_dim2 =  [675 675 675];
voxel_size2 = 2;

AA = Tiff([name, '_HR.tif'], 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
end
HR_image = double(image_dummy);

HR_image_filt_m = zeros(size(HR_image));
LR_image_filt_m = zeros(size(LR_image));

search_size = 11;
window_size = 5;
smoothing_lvl = 4.5;

for i =1:image_dim(3)
LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

LR_image_filt_8bit =  uint8(LR_image_filt_m);
LR_image_filt_bicubic_8bit = uint8(imresize3(LR_image_filt_m,3));

search_size = 11*3;
window_size = 5*3;
smoothing_lvl = 23.5;

for i = 1:image_dim2(3) 
HR_image_filt_m(:,:,i) = imnlmfilt(HR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

HR_image_filt_8bit =  uint8(HR_image_filt_m);

for i =1:image_dim(3)
   if (i > 1)
        imwrite(LR_image_filt_8bit(:,:,i),[name, '_LR_filtered.tif'],'WriteMode','append')
   else
       imwrite(LR_image_filt_8bit(:,:,i),[name, '_LR_filtered.tif'])
   end
end

for i =1:image_dim2(3)
   if (i > 1)
        imwrite(LR_image_filt_bicubic_8bit(:,:,i),[name, '_LR_bicubic_filtered.tif'],'WriteMode','append')
   else
       imwrite(LR_image_filt_bicubic_8bit(:,:,i),[name, '_LR_bicubic_filtered.tif'])
   end
end

for i =1:image_dim2(3)
   if (i > 1)
        imwrite(HR_image_filt_8bit(:,:,i),[name, '_HR_filtered.tif'],'WriteMode','append')
   else
       imwrite(HR_image_filt_8bit(:,:,i),[name, '_HR_filtered.tif'])
   end
end
end
toc

clc
clearvars
close all

name = 'Core2_Subvol1';
tic
for kkk = 1

image_dim =  [225 225 225];
voxel_size = 6;

AA = Tiff([name, '_LR.tif'], 'r');
image_dummy = [];
for i =1:image_dim(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim(3))
        nextDirectory(AA)
    end
    
end

LR_image = double(image_dummy);

image_dim2 =  [675 675 675];
voxel_size2 = 2;

AA = Tiff([name, '_HR.tif'], 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
end
HR_image = double(image_dummy);

HR_image_filt_m = zeros(size(HR_image));
LR_image_filt_m = zeros(size(LR_image));

search_size = 11;
window_size = 5;
smoothing_lvl = 4.5;

for i =1:image_dim(3)
LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

LR_image_filt_8bit =  uint8(LR_image_filt_m);
LR_image_filt_bicubic_8bit = uint8(imresize3(LR_image_filt_m,3));

search_size = 11*3;
window_size = 5*3;
smoothing_lvl = 23.5;

for i = 1:image_dim2(3) 
HR_image_filt_m(:,:,i) = imnlmfilt(HR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

HR_image_filt_8bit =  uint8(HR_image_filt_m);

for i =1:image_dim(3)
   if (i > 1)
        imwrite(LR_image_filt_8bit(:,:,i),[name, '_LR_filtered.tif'],'WriteMode','append')
   else
       imwrite(LR_image_filt_8bit(:,:,i),[name, '_LR_filtered.tif'])
   end
end

for i =1:image_dim2(3)
   if (i > 1)
        imwrite(LR_image_filt_bicubic_8bit(:,:,i),[name, '_LR_bicubic_filtered.tif'],'WriteMode','append')
   else
       imwrite(LR_image_filt_bicubic_8bit(:,:,i),[name, '_LR_bicubic_filtered.tif'])
   end
end

for i =1:image_dim2(3)
   if (i > 1)
        imwrite(HR_image_filt_8bit(:,:,i),[name, '_HR_filtered.tif'],'WriteMode','append')
   else
       imwrite(HR_image_filt_8bit(:,:,i),[name, '_HR_filtered.tif'])
   end
end
end
toc

clc
clearvars
close all


name = 'Core2_Subvol2';
tic
for kkk = 1

image_dim =  [225 225 225];
voxel_size = 6;

AA = Tiff([name, '_LR.tif'], 'r');
image_dummy = [];
for i =1:image_dim(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim(3))
        nextDirectory(AA)
    end
    
end

LR_image = double(image_dummy);

image_dim2 =  [675 675 675];
voxel_size2 = 2;

AA = Tiff([name, '_HR.tif'], 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
end
HR_image = double(image_dummy);

HR_image_filt_m = zeros(size(HR_image));
LR_image_filt_m = zeros(size(LR_image));

search_size = 11;
window_size = 5;
smoothing_lvl = 4.5;

for i =1:image_dim(3)
LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

LR_image_filt_8bit =  uint8(LR_image_filt_m);
LR_image_filt_bicubic_8bit = uint8(imresize3(LR_image_filt_m,3));

search_size = 11*3;
window_size = 5*3;
smoothing_lvl = 23.5;

for i = 1:image_dim2(3) 
HR_image_filt_m(:,:,i) = imnlmfilt(HR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

HR_image_filt_8bit =  uint8(HR_image_filt_m);

for i =1:image_dim(3)
   if (i > 1)
        imwrite(LR_image_filt_8bit(:,:,i),[name, '_LR_filtered.tif'],'WriteMode','append')
   else
       imwrite(LR_image_filt_8bit(:,:,i),[name, '_LR_filtered.tif'])
   end
end

for i =1:image_dim2(3)
   if (i > 1)
        imwrite(LR_image_filt_bicubic_8bit(:,:,i),[name, '_LR_bicubic_filtered.tif'],'WriteMode','append')
   else
       imwrite(LR_image_filt_bicubic_8bit(:,:,i),[name, '_LR_bicubic_filtered.tif'])
   end
end

for i =1:image_dim2(3)
   if (i > 1)
        imwrite(HR_image_filt_8bit(:,:,i),[name, '_HR_filtered.tif'],'WriteMode','append')
   else
       imwrite(HR_image_filt_8bit(:,:,i),[name, '_HR_filtered.tif'])
   end
end
end
toc
