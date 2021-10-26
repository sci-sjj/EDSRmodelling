% This code plots the average and 3D results from the continuum simulations
% of core 1 and 2. It uses data from the 'Continuum_modelling_results' folder
% which have been generated from
% 'A1_1_0_Generate_run_IMEX_continuum_model_core_1.m' and
% 'A1_1_1_Generate_run_IMEX_continuum_model_core_2.m'. 

clc
clearvars
close all

addpath('Matlab_results')
addpath('Exp_data')
addpath('Continuum_modelling_results')

colours =   [ 0 0 0; 0    0.4470    0.7410;0.8500    0.3250    0.0980;0.9290 ...
    0.6940    0.1250;0.4940    0.1840    0.5560; 0.4660    0.6740...
    0.1880; 0.3010    0.7450    0.9330; 0.6350    0.0780    0.1840];

load('Results_PNM_whole_core_LR_EDSR')

Data_continuum = cell(2,2,2);
for core = 1:2
    for resolution = 1:2
        for threshold = 1:2

            Data_continuum{core,resolution,threshold} = ...
                load(['Core', int2str(core), '_resolution_',int2str(resolution),...
                '_threshold_', int2str(threshold), '.mat']);
 
       end
    end
end

%%

load('kro_krw_so_soconn_min_mean_max_exp3.txt')
load('kro_krw_so_soconn_min_mean_max_exp2.txt')
load('kro_krw_so_soconn_min_mean_max_exp4.txt')

kro_exp2 = kro_krw_so_soconn_min_mean_max_exp2(:,1:3);
krw_exp2 = kro_krw_so_soconn_min_mean_max_exp2(:,4:6);
so_exp2 = kro_krw_so_soconn_min_mean_max_exp2(:,7:9);
sw_exp2(:,1:3) = 1- so_exp2(:,1:3);

kro_exp3 = kro_krw_so_soconn_min_mean_max_exp3(:,1:3);
krw_exp3 = kro_krw_so_soconn_min_mean_max_exp3(:,4:6);
so_exp3 = kro_krw_so_soconn_min_mean_max_exp3(:,7:9);
sw_exp3(:,1:3) = 1- so_exp3(:,1:3);

kro_exp4 = kro_krw_so_soconn_min_mean_max_exp4(:,1:3);
krw_exp4 = kro_krw_so_soconn_min_mean_max_exp4(:,4:6);
so_exp4 = kro_krw_so_soconn_min_mean_max_exp4(:,7:9);
sw_exp4(:,1:3) = 1- so_exp4(:,1:3);

nw_coeff = 4.6;
w_coeff =4.4;
kro_1 = 0.8;
krw_1 = 1;
swirr = 0.08;

sw_krw_kro_pc(:,1) = linspace(swirr,1, 100)';
sw_krw_kro_pc(:,2) = krw_1.*((sw_krw_kro_pc(:,1)-swirr)/(1-swirr)).^w_coeff;
sw_krw_kro_pc(:,3) = kro_1.*(1-((sw_krw_kro_pc(:,1)-swirr)/(1-swirr))).^nw_coeff;

N_up_xy = 13;
N_up_z = 12;

ds = 0.006*25;
ds_up_xy = N_up_xy.*ds;
ds_up_z = N_up_z.*ds;

offset_mct = 3.8;
L_tot_exp3 = 10800*0.006;

x_loc_exp3 = (ds_up_z/2:ds_up_z:(L_tot_exp3)) + offset_mct;

N_up_xy = 12;
N_up_z = 60;

Nx = 72;
Ny = 72;
Nz = 1800;

ds_xy = 0.006*1900/Nx;
ds_z = 0.006*1900/Nz*5;

ds_up_xy = N_up_xy.*ds_xy;
ds_up_z = N_up_z.*ds_z;

offset_mct = 3.6;
L_tot_exp4 = 9500*0.006;

x_loc_exp4 = (ds_up_z/2:ds_up_z:(L_tot_exp4)) + offset_mct;
%%
load('Core1_upscaled_saturations_3D_coarse_conn_new_align.mat')
load('Core1_upscaled_saturations_3D_coarse_disconn_new_align.mat')

Core1_saturations_SJJ = permute(((saturation_conn_upscaled(:,:,:,1:2) + saturation_disconn_upscaled(:,:,:,1:2))),[2 1 3 4] );
load('Core1_CZ_draFo05.mat', 'Water_sat_matrix')
Core1_saturations_CZ(:,:,:,1) = 1 - Water_sat_matrix;
load('Core1_CZ_draFo1.mat', 'Water_sat_matrix')
Core1_saturations_CZ(:,:,:,2) = 1 - Water_sat_matrix;
clear Water_sat_matrix saturation_conn_upscaled saturation_disconn_upscaled

Core1_saturations_CZ(Core1_saturations_CZ == 1) = NaN;

    for resolution = 1:2
        for threshold = 1:2
            Data_continuum{1,resolution,threshold}.satMat_sim(Core1_saturations_CZ == 0, 1)  = NaN;
            Data_continuum{1,resolution,threshold}.satMat_sim(Core1_saturations_CZ == 0, 2)  = NaN;
       end
    end

load('Core2_upscaled_saturations_3D_coarse_conn_new_align.mat')
load('Core2_upscaled_saturations_3D_coarse_disconn_new_align.mat')

Core2_saturations_SJJ = permute( (saturation_conn_upscaled(:,:,:,1:3) + saturation_disconn_upscaled(:,:,:,1:3)),[2 1 3 4]);
load('Core2_CZ_draFo05.mat', 'Water_sat_matrix')
Core2_saturations_CZ(:,:,:,1) = 1 - Water_sat_matrix;
load('Core2_CZ_draFo50.mat', 'Water_sat_matrix')
Core2_saturations_CZ(:,:,:,2) = 1 - Water_sat_matrix;
load('Core2_CZ_draFo1.mat', 'Water_sat_matrix')
Core2_saturations_CZ(:,:,:,3) = 1 - Water_sat_matrix;
clear Water_sat_matrix saturation_conn_upscaled saturation_disconn_upscaled

Core2_saturations_CZ(Core2_saturations_CZ == 1) = NaN;

for resolution = 1:2
        for threshold = 1:2
            Data_continuum{2,resolution,threshold}.satMat_sim(Core2_saturations_CZ == 0, 1)  = NaN;
            Data_continuum{2,resolution,threshold}.satMat_sim(Core2_saturations_CZ == 0, 2)  = NaN;
            Data_continuum{2,resolution,threshold}.satMat_sim(Core2_saturations_CZ == 0, 3)  = NaN;
        end
    end

%%
threshold = 1;
resolution = 2;

msize = 10;

figure1 = figure %('Position', [100,100,800,500]);
hold on

errorbar(sw_exp2(:,2), kro_exp2(:,2),(kro_exp2(:,2)-kro_exp2(:,1)),(kro_exp2(:,3)-kro_exp2(:,2)),(sw_exp2(:,2)-sw_exp2(:,1)),...
    (sw_exp2(:,3)-sw_exp2(:,2)), 'o','color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize)

errorbar(sw_exp2(:,2), krw_exp2(:,2),(krw_exp2(:,2)-krw_exp2(:,1)),(krw_exp2(:,3)-krw_exp2(:,2)),(sw_exp2(:,2)-sw_exp2(:,1)),...
    (sw_exp2(:,3)-sw_exp2(:,2)), 'd','color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize)

errorbar(sw_exp3(1:2,2), kro_exp3(1:2,2),(kro_exp3(1:2,2)-kro_exp3(1:2,1)),(kro_exp3(1:2,3)-kro_exp3(1:2,2)),(sw_exp3(1:2,2)-sw_exp3(1:2,1))...
    ,(sw_exp3(1:2,3)-sw_exp3(1:2,2)), 'o','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize)

errorbar(sw_exp3(1:2,2), krw_exp3(1:2,2),(krw_exp3(1:2,2)-krw_exp3(1:2,1)),(krw_exp3(1:2,3)-krw_exp3(1:2,2)),(sw_exp3(1:2,2)-sw_exp3(1:2,1)),...
    (sw_exp3(1:2,3)-sw_exp3(1:2,2)),'d','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize)

errorbar(sw_exp4(1:3,2), krw_exp4(1:3,2),(krw_exp4(1:3,2)-krw_exp4(1:3,1)),(krw_exp4(1:3,3)-krw_exp4(1:3,2)),(sw_exp4(1:3,2)-sw_exp4(1:3,1)),...
    (sw_exp4(1:3,3)-sw_exp4(1:3,2)),'d','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)

errorbar(sw_exp4(1:3,2), kro_exp4(1:3,2),(kro_exp4(1:3,2)-kro_exp4(1:3,1)),(kro_exp4(1:3,3)-kro_exp4(1:3,2)),(sw_exp4(1:3,2)-sw_exp4(1:3,1)),...
    (sw_exp4(1:3,3)-sw_exp4(1:3,2)),'o','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)

msize = 15;

plot(Data_continuum{1,resolution, threshold}.sol(:,3),Data_continuum{1,resolution, threshold}.sol(:,5), 'o','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerSize',msize)
plot(Data_continuum{1,resolution, threshold}.sol(:,3),Data_continuum{1,resolution, threshold}.sol(:,7),'d','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerSize',msize)

plot(Data_continuum{2,resolution, threshold}.sol(:,3),Data_continuum{2,resolution, threshold}.sol(:,5), 'o','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerSize',msize)
plot(Data_continuum{2,resolution, threshold}.sol(:,3),Data_continuum{2,resolution, threshold}.sol(:,7),'d','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerSize',msize)

plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,3), 'k--','linewidth', 2)
plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,2), 'k-','linewidth', 2)


L = legend('Oil $k_{ro}$ exp 1', 'Water $k_{rw}$ exp 1', 'Oil $k_{ro}$ exp 2', 'Water $k_{rw}$ exp 2', 'Oil $k_{ro}$ exp 3','Water $k_{rw}$ exp 3', 'Oil $k_{ro}$ sim 2','Water $k_{rw}$ sim 2','Oil $k_{ro}$ sim 3','Water $k_{rw}$ sim 3','BC Oil $k_{ro}$','BC Water $k_{rw}$','Location', 'EastOutside', 'fontsize', 14)
L.Interpreter = 'latex';
xlabel('Water saturation, $S_{w}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
ylabel('Relative permeability, $k_{r}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
set(gca, 'YScale', 'log')
axis([0.0 1 0.001 1])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)
%title(['Core ',int2str(core),' ', resolution_names{resolution}, ' Relative permeability log'], 'interpreter', 'latex', 'fontsize', 14)
%%
msize = 10;

colours =   [ 0.9290 ...
    0.6940    0.1250;0.4940    0.1840    0.5560; 0.4660    0.6740...
    0.1880; 0.3010    0.7450    0.9330; 0.6350    0.0780    0.1840];

figure1 = figure %('Position', [1000,100,800,500]);
hold on

errorbar(sw_exp2(:,2), kro_exp2(:,2),(kro_exp2(:,2)-kro_exp2(:,1)),(kro_exp2(:,3)-kro_exp2(:,2)),(sw_exp2(:,2)-sw_exp2(:,1)),...
    (sw_exp2(:,3)-sw_exp2(:,2)), 'o','color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize)

errorbar(sw_exp2(:,2), krw_exp2(:,2),(krw_exp2(:,2)-krw_exp2(:,1)),(krw_exp2(:,3)-krw_exp2(:,2)),(sw_exp2(:,2)-sw_exp2(:,1)),...
    (sw_exp2(:,3)-sw_exp2(:,2)), 'd','color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize)

errorbar(sw_exp3(1:2,2), kro_exp3(1:2,2),(kro_exp3(1:2,2)-kro_exp3(1:2,1)),(kro_exp3(1:2,3)-kro_exp3(1:2,2)),(sw_exp3(1:2,2)-sw_exp3(1:2,1))...
    ,(sw_exp3(1:2,3)-sw_exp3(1:2,2)), 'o','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize)

errorbar(sw_exp3(1:2,2), krw_exp3(1:2,2),(krw_exp3(1:2,2)-krw_exp3(1:2,1)),(krw_exp3(1:2,3)-krw_exp3(1:2,2)),(sw_exp3(1:2,2)-sw_exp3(1:2,1)),...
    (sw_exp3(1:2,3)-sw_exp3(1:2,2)),'d','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize)

errorbar(sw_exp4(1:3,2), krw_exp4(1:3,2),(krw_exp4(1:3,2)-krw_exp4(1:3,1)),(krw_exp4(1:3,3)-krw_exp4(1:3,2)),(sw_exp4(1:3,2)-sw_exp4(1:3,1)),...
    (sw_exp4(1:3,3)-sw_exp4(1:3,2)),'d','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)

errorbar(sw_exp4(1:3,2), kro_exp4(1:3,2),(kro_exp4(1:3,2)-kro_exp4(1:3,1)),(kro_exp4(1:3,3)-kro_exp4(1:3,2)),(sw_exp4(1:3,2)-sw_exp4(1:3,1)),...
    (sw_exp4(1:3,3)-sw_exp4(1:3,2)),'o','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)

msize = 15;

plot(Data_continuum{1,resolution, threshold}.sol(:,3),Data_continuum{1,resolution, threshold}.sol(:,5), 'o','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerSize',msize)
plot(Data_continuum{1,resolution, threshold}.sol(:,3),Data_continuum{1,resolution, threshold}.sol(:,7),'d','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerSize',msize)

plot(Data_continuum{2,resolution, threshold}.sol(:,3),Data_continuum{2,resolution, threshold}.sol(:,5), 'o','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerSize',msize)
plot(Data_continuum{2,resolution, threshold}.sol(:,3),Data_continuum{2,resolution, threshold}.sol(:,7),'d','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerSize',msize)

plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,3), 'k--','linewidth', 2)
plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,2), 'k-','linewidth', 2)

%L = legend('Oil $k_{ro}$ exp 1', 'Water $k_{rw}$ exp 1', 'Oil $k_{ro}$ exp 2', 'Water $k_{rw}$ exp 2', 'Oil $k_{ro}$ exp 3','Water $k_{rw}$ exp 3', 'Oil $k_{ro}$ sim 2','Water $k_{rw}$ sim 2','Oil $k_{ro}$ sim 3','Water $k_{rw}$ sim 3','BC Oil $k_{ro}$','BC Water $k_{rw}$','Location', 'EastOutside', 'fontsize', 14)
%L.Interpreter = 'latex';
xlabel('Water saturation, $S_{w}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
ylabel('Relative permeability, $k_{r}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
axis([0.0 1 0.001 1])
set(gca, 'YScale', 'log')
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)

%%


msize = 10;

figure1 = figure %('Position', [1000,100,800,500]);
hold on

errorbar(sw_exp2(:,2), kro_exp2(:,2),(kro_exp2(:,2)-kro_exp2(:,1)),(kro_exp2(:,3)-kro_exp2(:,2)),(sw_exp2(:,2)-sw_exp2(:,1)),...
    (sw_exp2(:,3)-sw_exp2(:,2)), 'o','color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize)

errorbar(sw_exp2(:,2), krw_exp2(:,2),(krw_exp2(:,2)-krw_exp2(:,1)),(krw_exp2(:,3)-krw_exp2(:,2)),(sw_exp2(:,2)-sw_exp2(:,1)),...
    (sw_exp2(:,3)-sw_exp2(:,2)), 'd','color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize)

errorbar(sw_exp3(1:2,2), kro_exp3(1:2,2),(kro_exp3(1:2,2)-kro_exp3(1:2,1)),(kro_exp3(1:2,3)-kro_exp3(1:2,2)),(sw_exp3(1:2,2)-sw_exp3(1:2,1))...
    ,(sw_exp3(1:2,3)-sw_exp3(1:2,2)), 'o','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize)

errorbar(sw_exp3(1:2,2), krw_exp3(1:2,2),(krw_exp3(1:2,2)-krw_exp3(1:2,1)),(krw_exp3(1:2,3)-krw_exp3(1:2,2)),(sw_exp3(1:2,2)-sw_exp3(1:2,1)),...
    (sw_exp3(1:2,3)-sw_exp3(1:2,2)),'d','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize)

errorbar(sw_exp4(1:3,2), krw_exp4(1:3,2),(krw_exp4(1:3,2)-krw_exp4(1:3,1)),(krw_exp4(1:3,3)-krw_exp4(1:3,2)),(sw_exp4(1:3,2)-sw_exp4(1:3,1)),...
    (sw_exp4(1:3,3)-sw_exp4(1:3,2)),'d','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)

errorbar(sw_exp4(1:3,2), kro_exp4(1:3,2),(kro_exp4(1:3,2)-kro_exp4(1:3,1)),(kro_exp4(1:3,3)-kro_exp4(1:3,2)),(sw_exp4(1:3,2)-sw_exp4(1:3,1)),...
    (sw_exp4(1:3,3)-sw_exp4(1:3,2)),'o','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)

msize = 15;

plot(Data_continuum{1,resolution, threshold}.sol(:,3),Data_continuum{1,resolution, threshold}.sol(:,5), 'o','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerSize',msize)
plot(Data_continuum{1,resolution, threshold}.sol(:,3),Data_continuum{1,resolution, threshold}.sol(:,7),'d','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerSize',msize)

plot(Data_continuum{2,resolution, threshold}.sol(:,3),Data_continuum{2,resolution, threshold}.sol(:,5), 'o','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerSize',msize)
plot(Data_continuum{2,resolution, threshold}.sol(:,3),Data_continuum{2,resolution, threshold}.sol(:,7),'d','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerSize',msize)

plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,3), 'k--','linewidth', 2)
plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,2), 'k-','linewidth', 2)

%L = legend('Oil $k_{ro}$ exp 1', 'Water $k_{rw}$ exp 1', 'Oil $k_{ro}$ exp 2', 'Water $k_{rw}$ exp 2', 'Oil $k_{ro}$ exp 3','Water $k_{rw}$ exp 3', 'Oil $k_{ro}$ sim 2','Water $k_{rw}$ sim 2','Oil $k_{ro}$ sim 3','Water $k_{rw}$ sim 3','BC Oil $k_{ro}$','BC Water $k_{rw}$','Location', 'EastOutside', 'fontsize', 14)
%L.Interpreter = 'latex';
xlabel('Water saturation, $S_{w}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
ylabel('Relative permeability, $k_{r}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
axis([0.0 1 0.0 0.25])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)

%%
msize = 5;

aa = Core1_saturations_SJJ(:,:,:,1);
bb = Data_continuum{1,resolution, threshold}.satMat_sim(:,:,2:37,2);
figure
hold on
plot(aa(:), bb(:),'o', 'color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)

aa = Core1_saturations_SJJ(:,:,:,2);
bb = Data_continuum{1,resolution, threshold}.satMat_sim(:,:,2:37,3);
plot(aa(:), bb(:),'o', 'color', colours (5,:),'MarkerEdge',colours (5,:),'MarkerFace',colours (5,:),'MarkerSize',msize)

plot(linspace(0, 1, 100), linspace(0, 1, 100), 'k-', 'linewidth', 2)

L = legend('$f_o = 0.05$', '$f_o = 1$' ,'Location', 'SouthEast', 'Interpreter', 'latex', 'fontsize', 18);
xlabel('Experiment oil saturation, $S_{o}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
ylabel('Simulation  oil saturation, $S_{o}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
axis([0 1 0 1])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)
ytickformat('%.1f')
xtickformat('%.1f')
msize = 7;

figure1 = figure %('Position', [100,100,800,500]);
hold on

aa = squeeze(nanmean(nanmean(Core1_saturations_SJJ(:,:,:,1))))';
bb =  squeeze(nanmean(nanmean(Data_continuum{1,resolution, threshold}.satMat_sim(:,:,2:37,2))))';
plot(x_loc_exp3/73.2,aa,'s--', 'linewidth', 2, 'color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)
plot(x_loc_exp3/73.2,bb, '-','linewidth', 2, 'color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)


aa = squeeze(nanmean(nanmean(Core1_saturations_SJJ(:,:,:,2))))';
bb =  squeeze(nanmean(nanmean(Data_continuum{1,resolution, threshold}.satMat_sim(:,:,2:37,3))))';
plot(x_loc_exp3/73.2, aa,'s--', 'linewidth', 2, 'color', colours (5,:),'MarkerEdge',colours (5,:),'MarkerFace',colours (5,:),'MarkerSize',msize)
plot(x_loc_exp3/73.2,bb, '-','linewidth', 2, 'color', colours (5,:),'MarkerEdge',colours (5,:),'MarkerFace',colours (3,:),'MarkerSize',msize)


L = legend('Exp $f_o = 0.05$','Sim $f_o = 0.05$','Exp $f_o = 1$','Sim $f_o = 1$','Location', 'NorthEast', 'Interpreter', 'latex', 'fontsize', 16);
xlabel('Distance from core inlet, $x/L$ [-]', 'Interpreter', 'latex', 'fontsize', 18)

ylabel('Oil saturation, $S_{o}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
axis([0 1 0 1])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)
ytickformat('%.1f')
xtickformat('%.1f')


%%

msize = 5;

figure
hold on

aa = Core2_saturations_SJJ(:,:,:,1);
bb = Data_continuum{2,resolution, threshold}.satMat_sim(:,:,2:31,2);

plot(aa(:), bb(:),'o', 'color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize)

aa = Core2_saturations_SJJ(:,:,:,2);
bb = Data_continuum{2,resolution, threshold}.satMat_sim(:,:,2:31,3);

plot(aa(:), bb(:),'o', 'color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize)

aa = Core2_saturations_SJJ(:,:,:,3);
bb = Data_continuum{2,resolution, threshold}.satMat_sim(:,:,2:31,4);

plot(aa(:), bb(:),'o', 'color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)

plot(linspace(0, 1, 100), linspace(0, 1, 100), 'k-', 'linewidth', 2)

L = legend('$f_o = 0.05$', '$f_o = 0.5$', '$f_o = 1$' ,'Location', 'SouthEast', 'Interpreter', 'latex', 'fontsize', 18);
xlabel('Experiment $nw$ saturation, $S_{nw}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
ylabel('Simulation  $nw$ saturation, $S_{nw}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
axis([0 1 0 1])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)
ytickformat('%.1f')
xtickformat('%.1f')

msize = 7;

%%
figure1 = figure %%('Position', [100,100,800,500]);
hold on

aa = squeeze(nanmean(nanmean(Core2_saturations_SJJ(:,:,:,1))))';
bb =  squeeze(nanmean(nanmean(Data_continuum{2,resolution, threshold}.satMat_sim(:,:,2:31,2))))';


plot(x_loc_exp4/64.7,aa,'o--', 'color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize)
plot(x_loc_exp4/64.7,bb, '-','linewidth', 2, 'color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize)

aa = squeeze(nanmean(nanmean(Core2_saturations_SJJ(:,:,:,2))))';
bb =  squeeze(nanmean(nanmean(Data_continuum{2,resolution, threshold}.satMat_sim(:,:,2:31,3))))';

plot(x_loc_exp4/64.7,aa,'o--', 'color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize)
plot(x_loc_exp4/64.7,bb, '-','linewidth', 2, 'color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize)


aa = squeeze(nanmean(nanmean(Core2_saturations_SJJ(:,:,:,3))))';
bb =  squeeze(nanmean(nanmean(Data_continuum{2,resolution, threshold}.satMat_sim(:,:,2:31,4))))';

plot(x_loc_exp4/64.7,aa,'o--', 'color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)
plot(x_loc_exp4/64.7,bb, '-','linewidth', 2, 'color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)


L = legend('Exp $f_o = 0.05$','Sim $f_o = 0.05$','Exp $f_o = 0.5$','Sim $f_o = 0.5$','Exp $f_o = 1$','Sim $f_o = 1$','Location', 'NorthEast', 'Interpreter', 'latex', 'fontsize', 14);
xlabel('Distance from core inlet, $x/L$ [-]', 'Interpreter', 'latex', 'fontsize', 18)

ylabel('Total $nw$ saturation, $S_{nw}$ [-]', 'Interpreter', 'latex', 'fontsize', 18)
axis([0 1 0 1])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)
ytickformat('%.1f')
xtickformat('%.1f')