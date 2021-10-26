clc
clearvars
close all

%Code to generate Cubic interpolation images from LR images. 

image_path = 'Raw_images/Final_raw_8bit_normalised_tif_LR_HR_SR/';  %Path name to LR images. 

name = 'Core2_Subvol2';

image_dim =  [225 225 225];
image_dim2 =  [675 675 675];

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

LR_image_filt_8bit =  uint8(image_dummy);
LR_image_filt_bicubic_8bit = uint8(imresize3(LR_image_filt_8bit,3));

for i =1:image_dim2(3)
   if (i > 1)
        imwrite(LR_image_filt_bicubic_8bit(:,:,i),[image_path,name, '_LR_bicubic.tif'],'WriteMode','append')
   else
       imwrite(LR_image_filt_bicubic_8bit(:,:,i),[image_path,name, '_LR_bicubic.tif'])
   end
end

