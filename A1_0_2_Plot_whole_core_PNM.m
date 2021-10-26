% This code plots the PNM petrophysical properties for the whole cores 1
% and 2. It uses data from the file 'Results_PNM_whole_core_LR_EDSR.mat'
% which has been generated and compiled from the individual PNM runs on each subvolume,
% in files 'A1_0_0_Generate_run_PNM_whole_core.m' and
% 'A1_0_1_Compile_whole_core_PNM.m' respectively. 

clc
clearvars
close all
restoredefaultpath

rootpath = pwd;
addpath(rootpath)

addpath('Matlab_results')
addpath('Exp_data')
addpath('Functions')

results_folder = [rootpath,'/PNM_whole_core_LR_EDSR_results/'];
save_folder = [rootpath,'/Matlab_results/'];

load([save_folder,'Results_PNM_whole_core_LR_EDSR'])


colours =   [ 0,0,0; 0    0.4470    0.7410;0.8500    0.3250    0.0980;0.9290 ...
    0.6940    0.1250;0.4940    0.1840    0.5560; 0.4660    0.6740...
    0.1880; 0.3010    0.7450    0.9330; 0.6350    0.0780    0.1840; 0.5 0.5 0.5];

%%
msize = 5;

load('Core2_upscaled_porosity_3D_coarse_new_align.mat')
load('Porosity_mct_exp4_perp.txt')
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
L_tot_exp3 = 9500*0.006;

Nx_up = round(Nx./N_up_xy);
Ny_up = round(Ny./N_up_xy);
Nz_up = round(Nz./N_up_z);

x_loc_exp4 = (ds_up_z/2:ds_up_z:(L_tot_exp3)) + offset_mct;


Porosities_mct_exp4_perp_interp = pchip((Porosity_mct_exp4_perp(:,1)),Porosity_mct_exp4_perp(:,2), x_loc_exp4');


por_av_slice = [];
    por_av_slice(:,1) = squeeze(nanmean(nanmean(porosity_upscaled(:,:,:,1))));
    por_av_slice(:,2) = squeeze(nanmean(nanmean(porosity_upscaled(:,:,:,2))));
    por_av_slice(:,3) = por_av_slice(:,2) + por_av_slice(:,1);


figure
hold on
plot(x_loc_exp4/64.7, Porosities_mct_exp4_perp_interp,  '-','color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp4/64.7, por_av_slice(:,3),  's-','color', colours (9,:),'MarkerEdge',colours (9,:),'MarkerFace',colours (9,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp4/64.7, por_av_slice(:,2),  's--','color', colours (9,:),'MarkerEdge',colours (9,:),'MarkerFace',colours (9,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp4/64.7,  por_im_slice_av{2,1,1}' ,  'd-','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp4/64.7,  por_im_slice_av{2,1,2}' ,  'o--','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp4/64.7,  por_im_slice_av{2,2,1}' ,  'd-','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp4/64.7,  por_im_slice_av{2,2,2}' ,  'o--','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize*1.2, 'linewidth', 2)

axis([0 1 0.17 0.24])


xlabel('Distance from core inlet, $x/L$ [-]', 'Interpreter', 'Latex','FontSize',16)
ylabel('Porosity, $\phi$ [-]', 'Interpreter', 'Latex','FontSize',16)

L = legend('Medical CT total porosity', 'Total porosity, Jackson $et$ $al.$ 2020','Macro porosity , Jackson $et$ $al.$ 2020','LR low threshold','LR high threshold', 'SR low threshold','SR high threshold', 'location', 'SouthWest' ,'Fontsize', 14);
L.Interpreter = 'Latex';
ytickformat('%.2f')
xtickformat('%.1f')
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','Latex')
set(gcf,'color','w');
grid on

%%
N_up_xy = 13;
N_up_z = 12;

Nx = 78;
Ny = 78;
Nz = 432;

ds = 0.006*25;
ds_up_xy = N_up_xy.*ds;
ds_up_z = N_up_z.*ds;

offset_mct = 3.8;
offset_scans = 0.072;

L_tot_exp3 = 10800*0.006;

Nx_up = round(Nx./N_up_xy);
Ny_up = round(Ny./N_up_xy);
Nz_up = round(Nz./N_up_z);

x_loc_exp3 = (ds_up_z/2:ds_up_z:(L_tot_exp3)) + offset_mct;

load('Core1_upscaled_porosity_3D_coarse_new_align.mat')
load('Porosities_mct_exp3_hom.txt')

x_location_good = x_loc_exp3';

Porosities_mct_exp3_hom_interp = pchip(Porosities_mct_exp3_hom(:,1),Porosities_mct_exp3_hom(:,2), x_loc_exp3');

por_av_slice = [];
    por_av_slice(:,1) = squeeze(nanmean(nanmean(porosity_upscaled(:,:,:,1))));
    por_av_slice(:,2) = squeeze(nanmean(nanmean(porosity_upscaled(:,:,:,2))));
    por_av_slice(:,3) = por_av_slice(:,2) + por_av_slice(:,1);

msize = 5;


figure
hold on
plot(x_loc_exp3/73.2, Porosities_mct_exp3_hom_interp,  '-','color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp3/73.2, por_av_slice(:,3),  's-','color', colours (9,:),'MarkerEdge',colours (9,:),'MarkerFace',colours (9,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp3/73.2, por_av_slice(:,2),  's--','color', colours (9,:),'MarkerEdge',colours (9,:),'MarkerFace',colours (9,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp3/73.2,  por_im_slice_av{1,1,1}' ,  'd-','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp3/73.2,  por_im_slice_av{1,1,2}' ,  'o--','color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp3/73.2,  por_im_slice_av{1,2,1}' ,  'd-','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize*1.2, 'linewidth', 2)
plot(x_loc_exp3/73.2,  por_im_slice_av{1,2,2}' ,  'o--','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize*1.2, 'linewidth', 2)

axis([0 1 0.15 0.22])

xlabel('Distance from core inlet, $x/L$ [-]', 'Interpreter', 'Latex','FontSize',16)
ylabel('Porosity, $\phi$ [-]', 'Interpreter', 'Latex','FontSize',16)

L = legend('Medical CT total porosity', 'Total porosity, Jackson $et$ $al.$ 2020','Macro porosity , Jackson $et$ $al.$ 2020','LR low threshold','LR high threshold', 'SR low threshold','SR high threshold', 'location', 'SouthWest' ,'Fontsize', 15);
L.Interpreter = 'Latex';
ytickformat('%.2f')
xtickformat('%.1f')
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','Latex')
set(gcf,'color','w');
grid on


%%

k_range = [36,30];
ranges = [3,4; 2,5; 1,6; 1,6; 2,5; 3,4];

colours =   [ 0,0,0; 0    0.4470    0.7410;0.8500    0.3250    0.0980;0.9290 ...
    0.6940    0.1250;0.4940    0.1840    0.5560; 0.4660    0.6740...
    0.1880; 0.3010    0.7450    0.9330; 0.6350    0.0780    0.1840; 0.5 0.5 0.5];

nw_coeff = 4.6;
w_coeff =4.4;
kro_1 = 0.8;
krw_1 = 1;
swirr = 0.08;

sw_krw_kro_pc(:,1) = linspace(swirr,1, 100)';
sw_krw_kro_pc(:,2) = krw_1.*((sw_krw_kro_pc(:,1)-swirr)/(1-swirr)).^w_coeff;
sw_krw_kro_pc(:,3) = kro_1.*(1-((sw_krw_kro_pc(:,1)-swirr)/(1-swirr))).^nw_coeff;

s1 = importdata('MICP.txt');
IFT_mercury = 0.485;
IFT_meso = 0.051;

s1(:,2) = s1(:,2)*6.89476*IFT_meso/IFT_mercury;

core = 2;
resolution = 2;
threshold = 2;

figure
hold on
        count = 0;
        for i = 1:6
            for j = ranges(i,1):ranges(i,2)
                for k = 1:k_range(core)
                    count = count + 1;
                    if (count == 1)
                        plot(s1(:,1), s1(:,2), 'ko-', 'markerfacecolor', 'k','linewidth', 2)
                    end
                    
                    plot( Data_PNM{core,resolution, threshold}.pc{i,j,k}(:,1), Data_PNM{core,resolution, threshold}.pc{i,j,k}(:,2)/1000, '-', 'linewidth', 1)
                   
                end
            end
        end
        
plot(s1(:,1), s1(:,2), 'ko-', 'markerfacecolor', 'k','linewidth', 2)
axis([0 1 0 10])
xlabel('Wetting saturation, $S_w$ [-]','interpreter','latex', 'fontsize', 16)
ylabel('Capillary pressure, $P_c$ [kPa]','interpreter','latex', 'fontsize', 16)
legend('MICP','Interpreter', 'latex', 'location', 'NorthEast', 'Fontsize', 18)
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)
ytickformat('%.0f')
xtickformat('%.1f')

count = 0;
figure
hold on
        
        for i = 1:6
            for j = ranges(i,1):ranges(i,2)
                for k = 1:k_range(core)
               
                    count = count + 1;
                    if (count == 1)
                        plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,3), 'k--','linewidth', 2)
                    end
                    
                    plot( Data_PNM{core,resolution, threshold}.kr{i,j,k}(:,1), Data_PNM{core,resolution, threshold}.kr{i,j,k}(:,3), '-', 'linewidth',1)
               
                end
            end
        end
        
 plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,3), 'k--','linewidth', 2)

xlabel('Water saturation, $S_w$ [-]', 'Interpreter', 'Latex', 'Fontsize', 16)
ylabel('NW relative permeability, $K_{r,nw}$ [-]', 'Interpreter', 'Latex', 'Fontsize', 16)
legend('BC $K_{r,nw}$ exp fit', 'Interpreter', 'latex', 'location', 'NorthEast', 'Fontsize', 18)
axis([0 1 0 1])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)
ytickformat('%.1f')
xtickformat('%.1f')

count = 0;
figure
hold on
        
        for i = 1:6
            for j = ranges(i,1):ranges(i,2)
                for k = 1:k_range(core)
               
                    count = count + 1;
                    if (count == 1)
                        plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,2), 'k-','linewidth', 2)
                    end
                    
                    plot( Data_PNM{core,resolution, threshold}.kr{i,j,k}(:,1), Data_PNM{core,resolution, threshold}.kr{i,j,k}(:,2), '-', 'linewidth',1)
               
                end
            end
        end
        
 plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,2), 'k-','linewidth', 2)

xlabel('Water saturation, $S_w$ [-]', 'Interpreter', 'Latex', 'Fontsize', 16)
ylabel('W relative permeability, $K_{r,w}$ [-]', 'Interpreter', 'Latex', 'Fontsize', 16)
legend('BC $K_{r,w}$ exp fit', 'Interpreter', 'latex', 'location', 'NorthWest', 'Fontsize', 18)
axis([0 1 0 1])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)
ytickformat('%.1f')
xtickformat('%.1f')

%%





core = 1;
resolution = 2;
threshold = 1;

Core1_porosity =  permute(porosity_upscaled(:,:,:,3),[2 1 3 4] );
Core1_por_im  = permute(Data_PNM{core,resolution, threshold}.por_im(:,:,:),[2 1 3] );
Core1_porosity(isnan(Core1_por_im)) = NaN; 
Core1_kabs  = permute(Data_PNM{core,resolution, threshold}.kabs(:,:,:),[2 1 3] );

DK = nanstd(Core1_kabs(:))./nanmean(Core1_kabs(:))

Core1_LR_kabs  = permute(Data_PNM{2,1, 1}.kabs(:,:,:),[2 1 3] );
Core1_SR_kabs  = permute(Data_PNM{2,2, 1}.kabs(:,:,:),[2 1 3] );

fig = figure;
fig.Color = 'white';
fig.Position = [250 250 470 390];

hold on
plot(Core1_SR_kabs(:),Core1_LR_kabs(:), 'ko')
p1 = plot(linspace(0,4000,100),linspace(0,4000,100),'k--', 'linewidth', 2)
p2 = plot(linspace(0,4000,100),linspace(0,4000,100)+1000,'k-', 'linewidth', 2)
xlim([0 4000])
ylim([0 4000])
legend([p1, p2], '$K_{LR} = K_{SR}$', '$K_{LR} = K_{SR} + 1000$mD',  'interpreter', 'latex', 'fontsize', 16, 'location', 'SouthEast')
xlabel('SR permeability, $K$ [mD]', 'Interpreter', 'Latex', 'fontsize', 18)
ylabel('LR permeability, $K$ [mD]', 'Interpreter', 'Latex', 'fontsize', 18)
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)
grid on
set(gcf,'color','w');        

ds_up_xy = 316*6e-6;
ds_up_z = 300*6e-6;

Nx_up = 6;
Ny_up = 6;
Nz_up = 36; 

for i = 1:Nx_up
    for j = 1:Ny_up
        for k =1:Nz_up
          xMat(i,j,k) = -j.*ds_up_xy;
          yMat(i,j,k) = -i.*ds_up_xy;
          zMat(i,j,k) = k.*ds_up_z;
        end
    end
end

plotting_matrix = Core1_kabs(:,:,:)/1000;
%plotting_matrix = Core1_por_im; %Core1_kabs(:,:,:)/1000


fig = figure;
fig.Color = 'white';
fig.Position = [250 250 1000 600];
hold 
for k = 1:Nz_up
    for i = 1:Nx_up
        for j = 1:Ny_up
           [x,y,z,d] = voxel_vertices([xMat(i,j,k),yMat(i,j,k), zMat(i,j,k)],ds_up_xy,ds_up_xy,ds_up_z, (plotting_matrix(j,i,k))) ;
            
                if (isnan(Data_PNM{core,resolution, threshold}.por_im(i,j,k))==0)
                    for l=1:6
                        patch(x(:,l),z(:,l),y(:,l),d(:,l));
                    end
                end
            end
        end
    end
 
view(45, 15);
hold off
axis equal
axis off
caxis([0 3.5]);
%caxis([0.15 0.25]);
 
ax = gca;
 c = colorbar(ax,'Position',...
    [0.916080000000001 0.400000000000001 0.0289199999999992 0.359999999999999],...
    'TickLabelInterpreter','latex',...
    'FontSize',18);
 hL = ylabel(c,'Permeability, $K_{abs}$ [D]', 'fontsize',18, 'interpreter', 'latex');     
 set(hL,'Rotation',90);
 
%  hL = ylabel(c,'Porosity, $\phi$ [-]', 'fontsize',18, 'interpreter', 'latex');     
%  set(hL,'Rotation',90);
 
 set(c,'TickLabelInterpreter','latex')
c.FontSize = 18;
c.Label.Interpreter = 'latex';
 
set(gcf,'color','w');

annotation(fig,'doublearrow',[0.125 0.813],[0.555 0.848333333333333]);
annotation(fig,'textbox',...
    [0.365 0.721666666666667 0.185 0.0516666666666673],'String',{'L = 6.48cm'},...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontWeight','bold',...
    'FontSize',24,...
    'FontName','Helvetica Neue',...
    'FitBoxToText','off');

%%

core = 2;
resolution = 2;
threshold = 1;

Core2_porosity =  permute(porosity_upscaled(:,:,:,3),[2 1 3 4] );
Core2_por_im  = permute(Data_PNM{core,resolution, threshold}.por_im(:,:,:),[2 1 3] );
Core2_porosity(isnan(Core2_por_im)) = NaN; 
Core2_kabs  = permute(Data_PNM{core,resolution, threshold}.kabs(:,:,:),[2 1 3] );

%Core2_kabs(Core2_kabs < 500) = Core2_kabs(Core2_kabs < 500)*0.1
DK = nanstd(Core2_kabs(:))./nanmean(Core2_kabs(:))
  

ds_up_xy = 316*6e-6;
ds_up_z = 318*6e-6;

Nx_up = 6;
Ny_up = 6;
Nz_up = 30; 

for i = 1:Nx_up
    for j = 1:Ny_up
        for k =1:Nz_up
          xMat(i,j,k) = -j.*ds_up_xy;
          yMat(i,j,k) = -i.*ds_up_xy;
          zMat(i,j,k) = k.*ds_up_z;
        end
    end
end

plotting_matrix = Core2_kabs(:,:,:)/1000;

fig = figure;
fig.Color = 'white';
fig.Position = [250 250 1000 600];
hold 
for k = 1:Nz_up
    for i = 1:Nx_up
        for j = 1:Ny_up
           [x,y,z,d] = voxel_vertices([xMat(i,j,k),yMat(i,j,k), zMat(i,j,k)],ds_up_xy,ds_up_xy,ds_up_z, (plotting_matrix(j,i,k))) ;
            
                if (isnan(Data_PNM{core,resolution, threshold}.por_im(i,j,k))==0)
                    for l=1:6
                        patch(x(:,l),z(:,l),y(:,l),d(:,l));
                    end
                end
            end
        end
    end
 
view(45, 15);
hold off
axis equal
axis off
caxis([0 3.5]);
ax = gca;
 c = colorbar(ax,'Position',...
    [0.916080000000001 0.400000000000001 0.0289199999999992 0.359999999999999],...
    'TickLabelInterpreter','latex',...
    'FontSize',18);

 hL = ylabel(c,'Permeability, $K_{abs}$ [D]', 'fontsize',18, 'interpreter', 'latex');     
 set(hL,'Rotation',90);

%  hL = ylabel(c,'Porosity, $\phi$ [-]', 'fontsize',18, 'interpreter', 'latex');     
%  set(hL,'Rotation',90);
 
 set(c,'TickLabelInterpreter','latex')
c.FontSize = 18;
c.Label.Interpreter = 'latex';
%c.TickLabelFormat = '%.1f';
set(gcf,'color','w');

annotation(fig,'doublearrow',[0.125 0.813],[0.555 0.848333333333333]);
annotation(fig,'textbox',...
    [0.365 0.721666666666667 0.185 0.0516666666666673],'String',{'L = 5.72cm'},...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontWeight','bold',...
    'FontSize',24,...
    'FontName','Helvetica Neue',...
    'FitBoxToText','off');
