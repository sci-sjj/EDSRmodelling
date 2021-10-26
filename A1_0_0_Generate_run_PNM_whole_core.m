% This code will generate PNM datafiles for the Core 1 and 2 whole core
% data, and run them using the ICL Github PNM extraction and flow codes:
% (https://github.com/ImperialCollegeLondon/pnextract)
% (https://github.com/ImperialCollegeLondon/pnflow)
% The PNM exectuables are stored in 'windows_binary_folder' below, 
% so need to be compiled and copied there. 
% This code also requires the functions 'pnextract_write_function_SJJ'
% 'pnflow_output_extraction_function' and 'pnflow_write_function_SJJ' found
% in the 'Functions' folder here. 
% The output of the code will be the full PNM petrophysical data for all subvolumes for all cores, at
% different thresholds, stored in /PNM_whole_core_LR_EDSR_results

clc
clearvars
close all

% Add flexible path to data
rootpath = pwd;
addpath(rootpath)
windows_binary_folder = [rootpath, '\Windows_PNM_binaries'];
save_folder = [rootpath,'\PNM_results'];
check_folder = [rootpath,'\check_folder'];

%Change these files and dimensions to the relevant core and image
%locations.
image_path_main = [rootpath, '\Core1\EDSR'];
image_dim =  [316*3 316*3 300*3];
threshold  = 104;
k_range = 36;

voxel_size = 2;
ranges = [3,4; 2,5; 1,6; 1,6; 2,5; 3,4];
count = 0;

%This is the filter levels. 
search_size = 11*3;
window_size = 5*3;
smoothing_lvl = 23.5;

for i = 1:6
    for j = ranges(i,1):ranges(i,2)
        for k = 1:k_range
            count = count + 1;
            loop_vals(count,1) = i;
            loop_vals(count,2) = j;
            loop_vals(count,3) = k;
        end
    end
end

total_its = count;
count = 0;

for loop_it =1:total_its
    i = loop_vals(loop_it,1);
    j = loop_vals(loop_it,2);
    k = loop_vals(loop_it,3);
    count = count + 1;
    tic
    
    
    if (isfile( [save_folder, '\Core1_EDSR_PNM_threshold_', int2str(threshold),'_output_i', int2str(i), '_j', int2str(j),'_k', int2str(k), '.mat'])...
           ||  isfile(  [check_folder, '\Core1_EDSR_PNM_threshold_', int2str(threshold),'_output_i', int2str(i), '_j', int2str(j),'_k', int2str(k), '.txt']))
       
        ss = ['Loop iteration ', int2str(count),  ', Subvolume count ', int2str(loop_it),  ', subvolume i', int2str(i),' j', int2str(j), ' k', int2str(k)];
        disp(ss)
        disp('Skipping as already done')
    else
    

    fid=fopen( [check_folder,'\Core1_EDSR_PNM_threshold_', int2str(threshold),'_output_i', int2str(i), '_j', int2str(j),'_k', int2str(k), '.txt'],'w');
    fclose(fid);
     
    ss = ['Loop iteration ', int2str(count),  ', Subvolume count ', int2str(loop_it),  ', subvolume i', int2str(i),' j', int2str(j), ' k', int2str(k)];
    disp(ss)
    
    fid=fopen('loop_iterations_Core1_1.txt','a+');
    fprintf(fid,'%s\n', ss);
    fclose(fid);

  
     
    image_name = ['Core_1_Full_Core_6_00um_subvol_i',int2str(i),...
        '_j', int2str(j), '_k', int2str(k), '_dry_8bit_scaled_edsr'];
    
    image_path = [image_path_main, '\Core1_EDSR_k', int2str(k)];
    
    AA = Tiff([image_path, '\',image_name,'.tif'], 'r');
    image_dummy = zeros(image_dim);
    for ii =1:image_dim(3)
        tt = read(AA);
        image_dummy(:,:,ii) = double(tt);
        if (ii<image_dim(3))
            nextDirectory(AA)
        end
    end
    
    
    image_seg = image_dummy > threshold;
    image_seg_8bit = uint8(image_seg);
    
    fid=fopen([image_path, '\', image_name,'.raw'],'w+');
    fwrite(fid, (permute(image_seg_8bit, [2 1 3])),'uint8');
    fclose(fid);
    
     porosity_image = 1- (sum(sum(sum(image_seg_8bit))))./(image_dim(1)*image_dim(2)*image_dim(3));
            
            clearvars image_seg image_seg_8bit image_dummy AA tt
    
    pnextract_file = ['pnextract_', image_name, '.mhd'];
    pnflow_file = ['pnflow_', image_name, '.dat'];
    
    new_folder_name = [image_name, '_PNM_folder'];
    mkdir(new_folder_name)
    
    gzip([image_path, '\', image_name,'.raw'], [rootpath, '\', new_folder_name])
    delete([image_path, '\', image_name,'.raw'])
    %Network parameters
    nRSmoothing = 3; %Must be an integer.
    RMedSurfNoise = 2.75;
    MSS = [ 0.98, 0.98, 0.7, RMedSurfNoise, 0.6, 1.1, nRSmoothing, 0.15, 1.75];
    minRPore = 3;
    
    %Fluid parameters
    vis_o = 0.803;
    vis_w = 0.783;
    rho_o = 723.8;
    rho_w = 1023.2;
    resistivity_w = 1.2;
    resistivity_o = 1000;
    ift = 51;
    ca_init = 45;
    ca_equil = 45;
    fluid_parameters = [ift, vis_w, vis_o, resistivity_w, resistivity_o, rho_w, rho_o, ca_init, ca_equil];
    
    %Saturation parameters
    swirr = 0.08;
    maxPc = 100000;
    delta_sw = 0.01;
    minDeltaPc = 1000;
    delta_Pc_fraction = 0.01;
    saturation_parameters = [swirr, maxPc,delta_sw,minDeltaPc, delta_Pc_fraction];
    
    %Solver parameters
    calc_box = '0.01 0.99';
    calc_Kr = ' T ';
    calc_I = ' F ';
    inject_left_right = ' T  F ';
    escape_left_right = ' T  T ';
    res_format = 'excel ';
    rel_perm_def = 'single F ';
    solver_params = '1.0E-30 8 0 F 0.0 '; %min tolerance,Memory Scaling factor, solver output, verbose solver, conducatance cut-off
    PRS_BDRS_params = 'F F 20 '; %calc kr using avg press, record press profiles, num press profiles
    sat_convergence = '5 0.001 0.5 2.0 T '; %minNumFillings,initStepSize,cutBack,maxIncr,stable disp
    visualise = {'F ', '1. ', '8 T T T F T '};
    rand_seed = '1002 ';
    drain_singlets = 'T ';
    
    % Write pnextract file
    pnextract_write_function_SJJ([image_name '.raw.gz'], pnextract_file,new_folder_name, MSS,minRPore, image_dim, voxel_size);
    
    %Write pnflow file
    pnflow_write_function_SJJ(image_name,pnflow_file, new_folder_name,fluid_parameters, saturation_parameters,calc_box,calc_Kr, calc_I,inject_left_right,...
        escape_left_right, res_format,rel_perm_def, solver_params , PRS_BDRS_params, sat_convergence, visualise,...
        rand_seed, drain_singlets);
    
    cd([rootpath, '\', new_folder_name])
    
    command = [windows_binary_folder,'\pnextract_CZ_2019.exe ', pnextract_file];
    system(command)
    command = [windows_binary_folder,'\pnflow_CZ_2019.exe ', pnflow_file];
    system(command)
    
    
    [pc_data, porosity_PNM, k_abs, rel_perm_data, network_data] =  pnflow_output_extraction_function([image_name, '_pnflow_results']);
    
    delete([image_name, '_link1.dat'], [image_name, '_link2.dat'], [image_name, '_node1.dat'], [image_name, '_node2.dat'],[image_name, '_VElems.mhd'], [image_name, '_VElems.raw.gz'])
    rmdir([image_name, '_pnflow_results', '_res'], 's')
    delete([image_name, '.raw.gz'])
    
    cd(rootpath)
    rmdir(new_folder_name, 's')
    
    save( [save_folder, '\Core1_EDSR_PNM_threshold_', int2str(threshold),'_output_i', int2str(i), '_j', int2str(j),'_k', int2str(k)],'pc_data', 'porosity_PNM', 'porosity_image', 'k_abs', 'rel_perm_data', 'network_data');
    toc
    end
end


