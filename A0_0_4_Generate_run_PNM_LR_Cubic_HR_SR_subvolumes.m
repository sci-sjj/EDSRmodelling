% This code will generate PNM datafiles for the Core 1 and 2 subvolume
% data, and run them using the ICL Github PNM extraction and flow codes:
% (https://github.com/ImperialCollegeLondon/pnextract)
% (https://github.com/ImperialCollegeLondon/pnflow)
% The PNM exectuables are stored in 'windows_binary_folder' below, 
% so need to be compiled and copied there. 
% This code also requires the functions 'pnextract_write_function_SJJ'
% 'pnflow_output_extraction_function' and 'pnflow_write_function_SJJ' found
% in the 'Functions' folder here. 
% The output of the code will be the full PNM petrophysical data for all LR/cubic/HR/SR subvolumes, at
% different thresholds, stored in /Matlab_results

clc
clearvars
close all

% Add flexible path to data
rootpath = pwd;
addpath(rootpath)
addpath('Functions')

windows_binary_folder = [rootpath,'\Windows_PNM_binaries'];

%Threshold for images

thresholds = [99.45;105.30;111.15;117.00;122.85;128.70;134.55];

%Image names and roots. 
image_roots = {'Core1_Subvol1_';'Core1_Subvol2_'; 'Core2_Subvol1_';'Core2_Subvol2_'};
image_resolutions = {'LR_filtered';'LR_bicubic_filtered';'HR_filtered'; 'SR'};
image_path = [rootpath, '\Core1_2_subvols\'];

%%
for kkk = 1:4
    
    for jjj = 1:4
        
        if (jjj > 1)
            image_dim =  [675 675 675];
            voxel_size = 2;
        else
            image_dim =  [225 225 225];
            voxel_size = 6;
        end
        
        
        
        for iii = 1:7
            
            image_name =  [image_roots{kkk}, image_resolutions{jjj}];
            
            AA = Tiff([image_path, '\',image_name,'.tif'], 'r');
            image_dummy = [];
            for i =1:image_dim(3)
                tt = read(AA);
                image_dummy(:,:,i) = tt;
                if (i<image_dim(3))
                    nextDirectory(AA)
                end
            end
            
            image_dummy = double(image_dummy);
            image_seg = image_dummy > thresholds(iii);
            image_seg_8bit = uint8(image_seg);
            
            fid=fopen([image_path, '\', image_name,'_', int2str(thresholds(iii)),'.raw'],'w+');
            fwrite(fid, (permute(image_seg_8bit, [2 1 3])),'uint8');
            fclose(fid);
            
            pnextract_file = ['pnextract_', image_name,'_', int2str(thresholds(iii)), '.mhd'];
            pnflow_file = ['pnflow_', image_name,'_', int2str(thresholds(iii)), '.dat'];
            
            new_folder_name = [image_name,'_', int2str(thresholds(iii))];
            mkdir(new_folder_name)
            
            gzip([image_path, '\', image_name,'_', int2str(thresholds(iii)),'.raw'], [rootpath, '\', new_folder_name])
            
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
            pnextract_write_function_SJJ([image_name,'_', int2str(thresholds(iii)) '.raw.gz'], pnextract_file,new_folder_name, MSS,minRPore, image_dim, voxel_size);
            
            %Write pnflow file
            pnflow_write_function_SJJ([image_name,'_', int2str(thresholds(iii))],pnflow_file, new_folder_name,fluid_parameters, saturation_parameters,calc_box,calc_Kr, calc_I,inject_left_right,...
                escape_left_right, res_format,rel_perm_def, solver_params , PRS_BDRS_params, sat_convergence, visualise,...
                rand_seed, drain_singlets);
            
            cd([rootpath, '\', new_folder_name])
            
            command = [windows_binary_folder,'\pnextract_CZ_2019.exe ', pnextract_file];
            system(command)
            command = [windows_binary_folder,'\pnflow_CZ_2019.exe ', pnflow_file];
            system(command)

            
            [pc_data, porosity, k_abs, rel_perm_data, network_data] =  pnflow_output_extraction_function([image_name,'_', int2str(thresholds(iii)), '_pnflow_results']);
            
            por = 1- (sum(sum(sum(image_seg_8bit))))./(image_dim(3)^3);
            pc{kkk,iii,jjj} = pc_data;
            phi_pnm(kkk,iii,jjj) = porosity;
            phi_image(kkk,iii,jjj) = por;
            kabs(kkk,iii,jjj) = k_abs;
            kr{kkk,iii,jjj} = rel_perm_data;
            network_stats{kkk,iii,jjj} = network_data;
            
            delete([image_name,'_', int2str(thresholds(iii)), '_link1.dat'], [image_name,'_', int2str(thresholds(iii)), '_link2.dat'], [image_name,'_', int2str(thresholds(iii)), '_node1.dat'], [image_name,'_', int2str(thresholds(iii)), '_node2.dat'],[image_name,'_', int2str(thresholds(iii)), '_VElems.mhd'], [image_name,'_', int2str(thresholds(iii)), '_VElems.raw.gz'])
            rmdir([image_name,'_', int2str(thresholds(iii)), '_pnflow_results', '_res'], 's')
            delete([image_name,'_', int2str(thresholds(iii)), '.raw.gz'])
            
            cd(rootpath)
            
            rmdir(new_folder_name, 's')
            
       
        end
    end
    
end

save('Matlab_results/Results_PNM_LR_HR_SR_sensitivity_all', 'pc', 'phi_pnm','phi_image', 'kabs', 'kr','network_stats');


