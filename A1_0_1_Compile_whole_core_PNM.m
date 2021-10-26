clc
clearvars
close all

%This code compiles results from the whole core PNM runs, which are in the
%folder 'PNM_whole_core_LR_EDSR_results' as individual i,j,k subvolumes for
%the different thresholds. 

% Add flexible path to data
rootpath = pwd;
addpath(rootpath)

results_folder = [rootpath,'/PNM_whole_core_LR_EDSR_results/'];
save_folder = [rootpath,'/Matlab_results/'];

k_range = [36,30];
ranges = [3,4; 2,5; 1,6; 1,6; 2,5; 3,4];
resolution_names = {'LR', 'EDSR'};
thresholds{1,1} = [117, 122]; thresholds{2,1} = [118, 123];
thresholds{1,2} = [104, 117]; thresholds{2,2} = [104, 119];

colours =   [ 0,0,0; 0    0.4470    0.7410;0.8500    0.3250    0.0980;0.9290 ...
    0.6940    0.1250;0.4940    0.1840    0.5560; 0.4660    0.6740...
    0.1880; 0.3010    0.7450    0.9330; 0.6350    0.0780    0.1840; 0.5 0.5 0.5];


for core =1:2
    
    
    for resolution = 1:2
        
        for threshold = 1:2
        
        for i = 1:6
            for j = ranges(i,1):ranges(i,2)
                for k = 1:k_range(core)
                    
                    if isfile([results_folder, 'Core',int2str(core),'_',resolution_names{resolution}, '_PNM_threshold_', int2str(thresholds{core,resolution}(threshold)), '_output_i', int2str(i), '_j', int2str(j),'_k', int2str(k), '.mat'])
                
                    
                    load([results_folder, 'Core',int2str(core),'_',resolution_names{resolution}, '_PNM_threshold_', int2str(thresholds{core,resolution}(threshold)), '_output_i', int2str(i), '_j', int2str(j),'_k', int2str(k)])
                    Data_PNM{core,resolution, threshold}.pc{i,j,k} = pc_data;
                    Data_PNM{core,resolution, threshold}.por_pnm(i,j,k) = porosity_PNM;
                    Data_PNM{core,resolution, threshold}.por_im(i,j,k) = porosity_image;
                    Data_PNM{core,resolution, threshold}.kabs(i,j,k) = k_abs;
                    Data_PNM{core,resolution, threshold}.kr{i,j,k} = rel_perm_data;
                    Data_PNM{core,resolution, threshold}.network{i,j,k} =  network_data;
                    clearvars pc_data porosity_PNM porosity_image k_abs rel_perm_data network_data
                    
                    else
                        disp(['Missing ', '\Core',int2str(core),'_',resolution_names{resolution}, '_PNM_threshold_', int2str(thresholds{core,resolution}(threshold)), '_output_i', int2str(i), '_j', int2str(j),'_k', int2str(k)])
                    end
                end
            end
        end
        
        Data_PNM{core,resolution, threshold}.por_im(Data_PNM{core,resolution, threshold}.por_im == 0) = NaN;
        Data_PNM{core,resolution, threshold}.por_pnm(Data_PNM{core,resolution, threshold}.por_pnm == 0) = NaN;
        Data_PNM{core,resolution, threshold}.kabs(Data_PNM{core,resolution, threshold}.kabs == 0) = NaN;
        end
    end
end

for core = 1:2
    for resolution = 1:2
        for threshold = 1:2
        por_im_slice_av{core, resolution, threshold} = squeeze(nanmean(nanmean(Data_PNM{core,resolution, threshold}.por_im)));
    
        end
    end
end

save([save_folder,'Results_PNM_whole_core_LR_EDSR'], 'Data_PNM', 'por_im_slice_av', 'k_range', 'ranges', 'resolution_names')
