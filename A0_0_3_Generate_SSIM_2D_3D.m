%Code to generate structural similarity index (SSIM) data for the Cubic, HR
%and SR images. 

clc
clearvars
close all

addpath('Matlab_results')
addpath('Exp_data')

%This path must be where the raw images are that you are comparing for SSIM
addpath('Raw_images/Final_raw_8bit_normalised_tif_LR_HR_SR')


image_dim =  [225 225 225];
voxel_size = 6;


AA = Tiff('Core1_Subvol1_LR.tif', 'r');
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
AA = Tiff('Core1_Subvol1_SR.tif', 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
    
end

SR_image = uint8(double(image_dummy));

AA = Tiff('Core1_Subvol1_HR.tif', 'r');
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

count = 0;
for ii = 1:20
count = count + 1;
smoothing_lvls1(count,1) = ii;
smoothing_lvl = ii;

for i =1:1 

LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic(:,:,1) = imresize(LR_image_filt_m(:,:,1),3,'nearest');
LR_image_filt_bicubic_8bit(:,:,1) =  uint8(LR_image_filt_bicubic(:,:,1));
similarity1(count,1) = ssim(LR_image_filt_bicubic_8bit(:,:,1), SR_image(:,:,1))
end



search_size = 11*3;
window_size = 5*3;
count = 0;

for ii = 13:32
count = count + 1;
smoothing_lvls1(count,2) = ii;
smoothing_lvl = ii;

for i = 1:1 
HR_image_filt_m(:,:,i) = imnlmfilt(HR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

HR_image_filt_m_8bit = uint8(HR_image_filt_m);
similarity1(count,2) = ssim(HR_image_filt_m_8bit(:,:,1), SR_image(:,:,1))
end


image_dim =  [225 225 225];
voxel_size = 6;

AA = Tiff('Core1_Subvol2_LR.tif', 'r');
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
AA = Tiff('Core1_Subvol2_SR.tif', 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
    
end

SR_image = uint8(double(image_dummy));

AA = Tiff('Core1_Subvol2_HR.tif', 'r');
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

count = 0;
for ii = 1:20
count = count + 1;
smoothing_lvls1(count,1) = ii;
smoothing_lvl = ii;

for i =1:1 

LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic(:,:,1) = imresize(LR_image_filt_m(:,:,1),3,'nearest');
LR_image_filt_bicubic_8bit(:,:,1) =  uint8(LR_image_filt_bicubic(:,:,1));
similarity2(count,1) = ssim(LR_image_filt_bicubic_8bit(:,:,1), SR_image(:,:,1))
end



search_size = 11*3;
window_size = 5*3;
count = 0;

for ii = 13:32
count = count + 1;
smoothing_lvls1(count,2) = ii;
smoothing_lvl = ii;

for i = 1:1 
HR_image_filt_m(:,:,i) = imnlmfilt(HR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

HR_image_filt_m_8bit = uint8(HR_image_filt_m);
similarity2(count,2) = ssim(HR_image_filt_m_8bit(:,:,1), SR_image(:,:,1))
end


image_dim =  [225 225 225];
voxel_size = 6;

AA = Tiff('Core2_Subvol1_LR.tif', 'r');
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
AA = Tiff('Core2_Subvol1_SR.tif', 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
    
end

SR_image = uint8(double(image_dummy));

AA = Tiff('Core2_Subvol1_HR.tif', 'r');
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

count = 0;
for ii = 1:20
count = count + 1;
smoothing_lvls2(count,1) = ii;
smoothing_lvl = ii;

for i =1:1 

LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic(:,:,1) = imresize(LR_image_filt_m(:,:,1),3,'nearest');
LR_image_filt_bicubic_8bit(:,:,1) =  uint8(LR_image_filt_bicubic(:,:,1));
similarity3(count,1) = ssim(LR_image_filt_bicubic_8bit(:,:,1), SR_image(:,:,1))
end

search_size = 11*3;
window_size = 5*3;
count = 0;

for ii = 13:32
count = count + 1;
smoothing_lvls2(count,2) = ii;
smoothing_lvl = ii;

for i = 1:1 
HR_image_filt_m(:,:,i) = imnlmfilt(HR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

HR_image_filt_m_8bit = uint8(HR_image_filt_m);
similarity3(count,2) = ssim(HR_image_filt_m_8bit(:,:,1), SR_image(:,:,1))
end


image_dim =  [225 225 225];
voxel_size = 6;

AA = Tiff('Core2_Subvol2_LR.tif', 'r');
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
AA = Tiff('Core2_Subvol2_SR.tif', 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
    
end

SR_image = uint8(double(image_dummy));

AA = Tiff('Core2_Subvol2_HR.tif', 'r');
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

count = 0;
for ii = 1:20
count = count + 1;
smoothing_lvls4(count,1) = ii;
smoothing_lvl = ii;

for i =1
LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic(:,:,1) = imresize(LR_image_filt_m(:,:,1),3,'nearest');
LR_image_filt_bicubic_8bit(:,:,1) =  uint8(LR_image_filt_bicubic(:,:,1));
similarity4(count,1) = ssim(LR_image_filt_bicubic_8bit(:,:,1), SR_image(:,:,1))
end
search_size = 11*3;
window_size = 5*3;
count = 0;

for ii = 13:32
count = count + 1;
smoothing_lvls4(count,2) = ii;
smoothing_lvl = ii;

for i = 1
HR_image_filt_m(:,:,1) = imnlmfilt(HR_image(:,:,1),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end

HR_image_filt_m_8bit(:,:,1) = uint8(HR_image_filt_m(:,:,1));
similarity4(count,2) = ssim(HR_image_filt_m_8bit(:,:,1), SR_image(:,:,1))
end

save('Filter_SSIM_results_2D', 'smoothing_lvls1', 'smoothing_lvls2','smoothing_lvls3','smoothing_lvls4',...
                            'similarity1', 'similarity2', 'similarity3', 'similarity4');

%%

clc
clearvars
close all

image_dim =  [225 225 225];
voxel_size = 6;

AA = Tiff('Core1_Subvol1_LR.tif', 'r');
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
AA = Tiff('Core1_Subvol1_SR.tif', 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
    
end

SR_image = uint8(double(image_dummy));

AA = Tiff('Core1_Subvol1_HR.tif', 'r');
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

count = 0;
for ii = 2:8
tic
count = count + 1;
smoothing_lvls1(count,1) = ii;
smoothing_lvl = ii;

for i =1:image_dim(3) 
LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic = imresize3(LR_image_filt_m,3,'nearest');
LR_image_filt_bicubic_8bit=  uint8(LR_image_filt_bicubic);
similarity1(count,1) = ssim(LR_image_filt_bicubic_8bit, SR_image)
toc
end

search_size = 11;
window_size = 5;

count = 0;
for ii = 2:8
tic
count = count + 1;
smoothing_lvls1(count,1) = ii;
smoothing_lvl = ii;

for i =1:1
LR_image_filt_m(:,:,1)= imnlmfilt(LR_image(:,:,1),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic(:,:,1) = imresize(LR_image_filt_m(:,:,1),3,'nearest');
LR_image_filt_bicubic_8bit(:,:,1)=  uint8(LR_image_filt_bicubic(:,:,1));
similarity1(count,2) = ssim(LR_image_filt_bicubic_8bit(:,:,1), SR_image(:,:,1))
toc
end

image_dim =  [225 225 225];
voxel_size = 6;

AA = Tiff('Core1_Subvol2_LR.tif', 'r');
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
AA = Tiff('Core1_Subvol2_SR.tif', 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
    
end

SR_image = uint8(double(image_dummy));

AA = Tiff('Core1_Subvol2_HR.tif', 'r');
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

count = 0;
for ii = 2:8
tic
count = count + 1;
smoothing_lvls1(count,1) = ii;
smoothing_lvl = ii;

for i =1:image_dim(3) 
LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic = imresize3(LR_image_filt_m,3,'nearest');
LR_image_filt_bicubic_8bit=  uint8(LR_image_filt_bicubic);
similarity2(count,1) = ssim(LR_image_filt_bicubic_8bit, SR_image)
toc
end

search_size = 11;
window_size = 5;

count = 0;
for ii = 2:8
tic
count = count + 1;
smoothing_lvls1(count,1) = ii;
smoothing_lvl = ii;

for i =1:1
LR_image_filt_m(:,:,1)= imnlmfilt(LR_image(:,:,1),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic(:,:,1) = imresize(LR_image_filt_m(:,:,1),3,'nearest');
LR_image_filt_bicubic_8bit(:,:,1)=  uint8(LR_image_filt_bicubic(:,:,1));
similarity2(count,2) = ssim(LR_image_filt_bicubic_8bit(:,:,1), SR_image(:,:,1))
toc
end


image_dim =  [225 225 225];
voxel_size = 6;

AA = Tiff('Core2_Subvol1_LR.tif', 'r');
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
AA = Tiff('Core2_Subvol1_SR.tif', 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
    
end

SR_image = uint8(double(image_dummy));
LR_image_filt_m = zeros(size(LR_image));


count = 0;
for ii = 2:8
tic
count = count + 1;
smoothing_lvls2(count,1) = ii;
smoothing_lvl = ii;

for i =1:image_dim(3) 
LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic = imresize3(LR_image_filt_m,3,'nearest');
LR_image_filt_bicubic_8bit=  uint8(LR_image_filt_bicubic);
similarity3(count,1) = ssim(LR_image_filt_bicubic_8bit, SR_image)
toc
end

search_size = 11;
window_size = 5;

count = 0;
for ii = 2:8
tic
count = count + 1;
smoothing_lvls2(count,1) = ii;
smoothing_lvl = ii;

for i =1:1
LR_image_filt_m(:,:,1)= imnlmfilt(LR_image(:,:,1),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic(:,:,1) = imresize(LR_image_filt_m(:,:,1),3,'nearest');
LR_image_filt_bicubic_8bit(:,:,1)=  uint8(LR_image_filt_bicubic(:,:,1));
similarity3(count,2) = ssim(LR_image_filt_bicubic_8bit(:,:,1), SR_image(:,:,1))
toc
end


image_dim =  [225 225 225];
voxel_size = 6;

AA = Tiff('Core2_Subvol2_LR.tif', 'r');
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
AA = Tiff('Core2_Subvol2_SR.tif', 'r');
image_dummy = [];
for i =1:image_dim2(3)
    tt = read(AA);
    image_dummy(:,:,i) = tt;
    if (i<image_dim2(3))
        nextDirectory(AA)
    end
    
end

SR_image = uint8(double(image_dummy));
LR_image_filt_m = zeros(size(LR_image));

search_size = 11;
window_size = 5;

count = 0;
for ii = 2:8
tic
count = count + 1;
smoothing_lvls3(count,1) = ii;
smoothing_lvl = ii;

for i =1:image_dim(3) 
LR_image_filt_m(:,:,i)= imnlmfilt(LR_image(:,:,i),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic = imresize3(LR_image_filt_m,3,'nearest');
LR_image_filt_bicubic_8bit=  uint8(LR_image_filt_bicubic);
similarity4(count,1) = ssim(LR_image_filt_bicubic_8bit, SR_image)
toc
end

search_size = 11;
window_size = 5;

count = 0;
for ii = 2:8
tic
count = count + 1;
smoothing_lvls3(count,1) = ii;
smoothing_lvl = ii;

for i =1:1
LR_image_filt_m(:,:,1)= imnlmfilt(LR_image(:,:,1),'DegreeOfSmoothing',smoothing_lvl, 'SearchWindowSize', search_size,'ComparisonWindowSize',window_size );
end
LR_image_filt_bicubic(:,:,1) = imresize(LR_image_filt_m(:,:,1),3,'nearest');
LR_image_filt_bicubic_8bit(:,:,1)=  uint8(LR_image_filt_bicubic(:,:,1));
similarity4(count,2) = ssim(LR_image_filt_bicubic_8bit(:,:,1), SR_image(:,:,1))
toc
end


save('Filter_SSIM_results_3D', 'smoothing_lvls1', 'smoothing_lvls2','smoothing_lvls3',...
                            'similarity1', 'similarity2', 'similarity3', 'similarity4');
                        