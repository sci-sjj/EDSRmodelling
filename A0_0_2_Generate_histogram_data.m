clc
clearvars
close all
tic

%Code to create histogram data from images.
%Change image path to where the images are stored below and it will output
%a histogram .mat file in the top level directory. 

image_path = 'Filtered_images/';

for kkk = 1:4
    
    if (kkk == 1)
        name = 'Core1_Subvol1';
    elseif (kkk == 2)
        name = 'Core1_Subvol2';
    elseif ( kkk == 3)
        name = 'Core2_Subvol1';
    else
        name = 'Core2_Subvol2';
    end
    
    image_dim =  [225 225 225];
    voxel_size = 6;
    
    AA = Tiff([image_path,name, '_LR_filtered.tif'], 'r');
    image_dummy = [];
    for i =1:image_dim(3)
        tt = read(AA);
        image_dummy(:,:,i) = tt;
        if (i<image_dim(3))
            nextDirectory(AA)
        end
        
    end
    
    LR_image = double(image_dummy);
    
    image_vec{kkk,1} = LR_image(:);
    
    image_dim2 =  [675 675 675];
    voxel_size2 = 2;
    
     AA = Tiff([image_path, name, '_LR_bicubic_filtered.tif'], 'r');
    image_dummy = [];
    for i =1:image_dim2(3)
        tt = read(AA);
        image_dummy(:,:,i) = tt;
        if (i<image_dim2(3))
            nextDirectory(AA)
        end
    end
    LRB_image = double(image_dummy);
    
    image_vec{kkk,2} =  LRB_image(:);
    
    AA = Tiff([image_path,name, '_HR_filtered.tif'], 'r');
    image_dummy = [];
    for i =1:image_dim2(3)
        tt = read(AA);
        image_dummy(:,:,i) = tt;
        if (i<image_dim2(3))
            nextDirectory(AA)
        end
    end
    HR_image = double(image_dummy);
    
    image_vec{kkk,3} = HR_image(:);
    
    AA = Tiff([image_path,name, '_SR.tif'], 'r');
    image_dummy = [];
    for i =1:image_dim2(3)
        tt = read(AA);
        image_dummy(:,:,i) = tt;
        if (i<image_dim2(3))
            nextDirectory(AA)
        end
    end
    SR_image = double(image_dummy);
    
    image_vec{kkk,4} = SR_image(:);
    
end
save('Raw_histograms_3D_filtered', 'image_vec', '-v7.3')
