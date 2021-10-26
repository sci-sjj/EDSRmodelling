% This code creates the IMEX continuum model for core 2 from the PNM files. It
% then runs the IMEX code (through a system call in Matlab) and processes
% the results. You must have IMEX installed for this to work, and the right
% directory defined. It then stores the results in .mat datafiles which are
% found in 'Continuum_modelling_results' folder'
% 
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

load('Core2_upscaled_saturations_3D_coarse_conn_new_align.mat')
load('Core2_upscaled_saturations_3D_coarse_disconn_new_align.mat')

Core2_saturations_SJJ = permute(((saturation_conn_upscaled(:,:,:,1:3) + saturation_disconn_upscaled(:,:,:,1:3))),[2 1 3 4] );
load('Core2_CZ_draFo05.mat', 'Water_sat_matrix')
Core2_saturations_CZ(:,:,:,1) = 1 - Water_sat_matrix;
load('Core2_CZ_draFo50.mat', 'Water_sat_matrix')
Core2_saturations_CZ(:,:,:,2) = 1 - Water_sat_matrix;
load('Core2_CZ_draFo1.mat', 'Water_sat_matrix')
Core2_saturations_CZ(:,:,:,3) = 1 - Water_sat_matrix;
clear Water_sat_matrix saturation_conn_upscaled saturation_disconn_upscaled

Core2_saturations_CZ(Core1_saturations_CZ == 1) = NaN;

core = 2;
resolution = 1;
threshold = 1;

kabs_m2_to_mD = 1.01324996582814E+15;

porosity = Data_PNM{core, resolution, threshold}.por_im;
kabs = Data_PNM{core, resolution, threshold}.kabs;
kabs_av = geomean(kabs(:), 'omitnan');
porosity_av = nanmean(porosity(:));

kr = Data_PNM{core, resolution, threshold}.kr;
pc = Data_PNM{core, resolution, threshold}.pc;

Nx = 6;
Ny = 6;
Nz = 30;

n_tab = 101;
av_sw = linspace(0.0, 1, n_tab)';
krw_av1 = zeros(size(av_sw));
krg_av1 = zeros(size(av_sw));
pc_av1 = zeros(size(av_sw));
porosity_av1 = 0;
kabs_av1 = 0;


for i = 1:Nx
    for j = 1:Ny
        for k = 1:Nz
        if (isnan(porosity(i,j,k)) == 0)
       kr{i,j,k} = flipud(kr{i,j,k});
       pc{i,j,k} = flipud(pc{i,j,k});
       
        [~,unique_rows]  = unique((kr{i,j,k}(:,1)));
        kr{i,j,k} = [kr{i,j,k}(unique_rows,1) ,kr{i,j,k}(unique_rows,2), kr{i,j,k}(unique_rows,3)];
        pc{i,j,k} = [pc{i,j,k}(unique_rows,1) ,pc{i,j,k}(unique_rows,2)];
        pc{i,j,k}(end,2) = pc{i,j,k}(end-1,2);
        kr{i,j,k} = flipud(kr{i,j,k});
       pc{i,j,k} = flipud(pc{i,j,k});
       
        
        end
        end
        end
end
    
krw_av2 = zeros(size(av_sw));
krg_av2 = zeros(size(av_sw));
pc_av2 = zeros(size(av_sw));
porosity_av2 = 0;
kabs_av2 = 0;
count = 0;

for i = 1:Nx
    for j = 1:Ny
        for k = 1:Nz
        if (isnan(porosity(i,j,k)) == 0)
        count = count + 1;
        
        [~,unique_rows]  = unique(kr{i,j,k}(:,1));
        
        krw_av1 = krw_av1 + pchip(kr{i,j,k}(unique_rows,1), kr{i,j,k}(unique_rows,2), av_sw);
        krg_av1 = krg_av1 + pchip(kr{i,j,k}(unique_rows,1), kr{i,j,k}(unique_rows,3), av_sw);
        pc_av1 = pc_av1 + pchip(pc{i,j,k}(unique_rows,1), pc{i,j,k}(unique_rows,2), av_sw);
        porosity_av1 =  porosity_av1 + porosity(i,j,k);
        kabs_av1 =  kabs_av1 + kabs(i,j,k); 
         
        end
        end
    end
end

krw_av1 = krw_av1/count;
krg_av1 = krg_av1/count;
pc_av1 = pc_av1/count;
porosity_av1 =  porosity_av1/count;
kabs_av1 =  kabs_av1/count;

pe =  3.7 %pc_av1(91)/1000

%%pe =; %3.7;

krg_lin = linspace(0,1,100)';
krw_lin = linspace(1,0,100)';
sw_lin = linspace(0,1,100)';
pc_lin = ones(1,100)'*pe;
linear_tab_len = length(pc_lin);


kabs(:,:,2:Nz+1) = kabs(:,:,:);
kabs(:,:,[1,Nz+2]) = kabs(:,:,[2,Nz])*0 + 20000;

porosity(:,:,2:Nz+1) = porosity(:,:,:);
porosity(:,:,[1,Nz+2]) = porosity(:,:,[2,Nz])*0 + 0.2;

Nz = Nz + 2;

RowInd = 0;
por_to_file = zeros(Nx*Ny*Nz,4);
pc_end_to_file = zeros(Nx*Ny*Nz,4);

for i = 1:Nx
    for j = 1:Ny
        for k = 1:Nz
            i_pos = j;
            j_pos = i;
            k_pos = k;
            RowInd = RowInd + 1;
            
            if (isnan(porosity(i,j,k)))
                por_to_file(RowInd,:) = [0,i_pos,j_pos,k_pos];
                kabs_to_file(RowInd,:) = [0,i_pos,j_pos,k_pos];
            else
                por_to_file(RowInd,:) = [porosity(i,j,k),i_pos,j_pos,k_pos];
                kabs_to_file(RowInd,:) = [kabs(i,j,k),i_pos,j_pos,k_pos];
            end
        end
    end
end

fileID = fopen(['Core',int2str(core),'_mod_por_PNM_', resolution_names{resolution}, '.inc'],'w');
for i = 1:(RowInd)
    fprintf(fileID,'%u %u %u %1s %12.8f\r\n', por_to_file(i,2), por_to_file(i,3),  por_to_file(i,4),'=',  por_to_file(i,1));
end
fclose(fileID);

fileID = fopen(['Core',int2str(core),'_mod_kabs_PNM_', resolution_names{resolution}, '.inc'],'w');
for i = 1:(RowInd)
    fprintf(fileID,'%u %u %u %1s %12.8f\r\n', kabs_to_file(i,2), kabs_to_file(i,3),  kabs_to_file(i,4),'=',  kabs_to_file(i,1));
end
fclose(fileID);

non_mono_check = 0;
fileID = fopen(['Core',int2str(core),'_mod_RPT_tables_PNM_', resolution_names{resolution}, '.inc'],'w');
count = 0;
for i = 1:Nx
    for j = 1:Ny
        for k = 1:Nz
            count = count+1;
            fprintf(fileID, '%s\r\n', ['*RPT ', int2str(count)]);
            fprintf(fileID, '%s\r\n', 'SWT SWTKRTHR 5e-16');
            
            if (isnan(porosity(i,j,k))) ||  (k == Nz) || (k == 1)
                for t = 1:linear_tab_len
                    fprintf(fileID, '%s\r\n',  [num2str(  sw_lin(t,1), '%25.15f'),'   ',num2str(krg_lin(t,1), '%25.15f'),'   ',num2str(krw_lin(t,1), '%25.15f'),'   ',num2str(pc_lin(t,1), '%25.15f')]);
                end
            else
                
                table = Data_PNM{core, resolution, threshold}.kr{i,j,k-1}(:,1:3);
                table(:,4) = Data_PNM{core, resolution, threshold}.pc{i,j,k-1}(:,2)./1000;
                table = flipud(table); table(1,2) = 0;  table(end, 3) = 0;
                [tab_size, ~] = size(table);
                
                sw_last = -inf;
                krg_last = inf;
                krw_last = -inf;
                pc_last = inf;
                
                for t = 1:tab_size
                    if (table(t,1) > sw_last) && ((table(t,3) <= krg_last)) && (table(t,2) > krw_last) && (table(t,4) < pc_last)
                        fprintf(fileID, '%s\r\n',  [num2str(  table(t,1), '%25.15f'),'   ',num2str(table(t,2), '%25.15f'),'   ',num2str(table(t,3), '%25.15f'),'   ',num2str(table(t,4), '%25.15f')]);
                        
                        sw_last = table(t,1);
                        krg_last = table(t,3);
                        krw_last = table(t,2);
                        pc_last = table(t,4);
                    end
                end
            end
            fprintf(fileID, '%s\r\n', ' ');
            fprintf(fileID, '%s\r\n', ' ');
        end
    end
end

fprintf(fileID, '%s\r\n', '');
fprintf(fileID, '%s\r\n', '*RTYPE CON 1');
fprintf(fileID, '%s\r\n', '*MOD');
fprintf(fileID, '%s\r\n', '');
count = 0;
for i = 1:Nx
    for j = 1:Ny
        for k = 1:Nz
            i_pos = j;
            j_pos = i;
            k_pos = k;
            
            count = count + 1;
            
            fprintf(fileID,'%u %u %u %1s %u \r\n',i_pos,j_pos, k_pos,' = ',count );
        end
    end
end
fclose(fileID);

fileID = fopen(['Core',int2str(core),'_IMEX_PNM_', resolution_names{resolution}, '_report_gen.rwd'],'w');
fprintf(fileID, '%s\r\n', ['*FILE ', '''','Core',int2str(core),'_IMEX_PNM_', resolution_names{resolution}, '.irf''']);
fprintf(fileID, '%s\r\n', ['*OUTPUT ', '''','Core',int2str(core),'_IMEX_PNM_', resolution_names{resolution},'_Pressure_sim','.txt''']);
fprintf(fileID, '%s\r\n', ['*PROPERTY-FOR ', '''PRES''', ' *ALL-TIMES']);
fprintf(fileID, '%s\r\n', '*SRF-FORMAT');
fprintf(fileID, '%s\r\n', '  ');

fprintf(fileID, '%s\r\n', ['*OUTPUT ', '''','Core',int2str(core),'_IMEX_PNM_', resolution_names{resolution},'_Oil_Saturation_sim','.txt''']);
fprintf(fileID, '%s\r\n', ['*PROPERTY-FOR ', '''SO''', ' *ALL-TIMES']);
fprintf(fileID, '%s\r\n', '*SRF-FORMAT');
fprintf(fileID, '%s\r\n', '  ');

fprintf(fileID, '%s\r\n', ['*OUTPUT ', '''','Core',int2str(core),'_IMEX_PNM_', resolution_names{resolution},'_Por_sim','.txt''']);
fprintf(fileID, '%s\r\n', ['*PROPERTY-FOR ', '''POR''', ' *ALL-TIMES']);
fprintf(fileID, '%s\r\n', '*SRF-FORMAT');
fprintf(fileID, '%s\r\n', '  ');
fclose(fileID);

filename =['Core',int2str(core),'_IMEX_PNM_', resolution_names{resolution},'.dat '];
system(['"C:\Program Files (x86)\CMG\IMEX\2017.10\Win_x64\EXE\mx201710.exe"', ' -f ', filename, '']);

porosity = Data_PNM{core, resolution, threshold}.por_im;

colours =   [ 0    0.4470    0.7410;0.8500    0.3250    0.0980;0.9290 ...
    0.6940    0.1250;0.4940    0.1840    0.5560; 0.4660    0.6740...
    0.1880; 0.3010    0.7450    0.9330; 0.6350    0.0780    0.1840];

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

%---------------------------------------------------
Nx = 6;
Ny = 6;
Nz = 32;

Nt = 4; % Number of fractional flow steps in the experiment

dy = 0.001896;
dx = 0.001896;
dz = 0.001908;

slice_voxels = 24;
inlet_slice = 1;
outlet_slice = 32;

exe_path = '"C:\Program Files (x86)\CMG\BR\2017.10\Win_x64\EXE\report.exe"';

filename = ['Core',int2str(core),'_IMEX_PNM_', resolution_names{resolution}, '_report_gen'];
[status, cmdout] = system([exe_path, ' -f ', filename, '.rwd -o ', filename, '.out'])

headers = 6;
string = ['findstr /v "''" ',  '"Core',int2str(core),'_IMEX_PNM_', resolution_names{resolution},'_Pressure_sim','.txt"'    '>', 'dummy01.txt'];
dos(string)
pressMat_IMEX_q_1 = dlmread('dummy01.txt');

string = ['findstr /v "''" ', '"Core',int2str(core),'_IMEX_PNM_', resolution_names{resolution},'_Oil_Saturation_sim','.txt"'    '>', 'dummy02.txt'];
dos(string)
satMat_IMEX_q_1 = dlmread('dummy02.txt');

string = ['findstr /v "''" ', '"Core',int2str(core),'_IMEX_PNM_', resolution_names{resolution},'_Por_sim','.txt"'    '>', 'dummy03.txt'];
dos(string)
porMat_IMEX_q_1 = dlmread('dummy03.txt');

[~,n] = size(pressMat_IMEX_q_1);
count = 0;

remd =  n - rem(Nz*Nx*Ny, n);

pressMat_sim = zeros(Nx, Ny, Nz,  Nt);
satMat_sim = nan(Nx, Ny, Nz,  Nt);
porMat_sim = nan(Nx, Ny, Nz,  Nt);

if (remd == n)
    remd =0;
end

for t = 1:Nt+1
    
    if (t==1)
        count = 0;
    else
        count = count + remd;
    end
    
    for k = 1:Nz
        for j = 1:Ny
            for i = 1:Nx
                count  = count + 1 ;
                
                row = ceil(count/n);
                col = rem(count,n);
                
                if (col==0)
                    col = n;
                end
                
                if (t>1)
                    
                    pressMat_sim(i,j,k,t-1) = pressMat_IMEX_q_1(row,col);
                    satMat_sim(i,j,k,t-1) = satMat_IMEX_q_1(row,col);
                    
                    
                end
                
                if (t == 1)
                    
                    porMat_sim(i,j,k,t) = porMat_IMEX_q_1(row,col);
                end
            end
        end
    end
end

satMat_sim(satMat_sim == 0) = NaN;
pressMat_sim(pressMat_sim == 0) = NaN;

sat_av(1:3,1) = 1 - nanmean(nanmean(nanmean(satMat_sim(:,:,2:Nz-1,2:4))));
sat_av_exp(1:3,1) = 1 - nanmean(nanmean(nanmean(Core2_saturations_CZ(:,:,:,1:3))))*1.15;


core_L = dz*(Nz-1);
core_A = dy*dx*slice_voxels;
vis_g = 0.0008032;
vis_w = 0.0007833;

rho_g = 723.8000000;
rho_w = 1023.1964873;
g_accel = 9.81;

q_g =[0,6.00181860020217e-11,6.00181860020217e-10,1.20036372004043e-09]';
q_w =[1.20036372004043e-09,1.14034553403841e-09,6.00181860020217e-10,0]';

del_p = zeros(Nt,1);

for f = 1:Nt
    
    av_inlet = 0;
    av_outlet = 0;
    
    for i = 1:Nx
        for j = 1:Ny
            if (isnan(porosity(i,j,2)) == 0)
                av_inlet = av_inlet + pressMat_sim(i,j,inlet_slice,f);
                av_outlet = av_outlet + pressMat_sim(i,j,outlet_slice,f);
                
            end
        end
    end
    av_inlet = av_inlet/slice_voxels;
    av_outlet = av_outlet/slice_voxels;
    
    del_p(f) = (av_inlet - av_outlet)*1000;
end

k_abs = q_w(1).*vis_w.*core_L./(core_A.*(del_p(1)-rho_w.*core_L*g_accel));

kr_g(1:Nt-1) = q_g(2:Nt).*vis_g.*core_L./(k_abs.*core_A.*(del_p(2:Nt)-rho_g.*core_L*g_accel));
kr_w(1:Nt-1) = q_w(2:Nt).*vis_w.*core_L./(k_abs.*core_A.*(del_p(2:Nt)-rho_w.*core_L*g_accel));



msize = 5;

figure1 = figure('Position', [100,100,800,500]);
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

msize = 10;

plot((sat_av(1:Nt-1)), kr_g(1:Nt-1), 'o','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerSize',msize)
plot((sat_av(1:Nt-1)), kr_w(1:Nt-1),'d','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerSize',msize)

plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,3), 'k--','linewidth', 2)
plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,2), 'k-','linewidth', 2)


msize = 5;

L = legend('Oil $k_{ro}$ exp 1', 'Water $k_{rw}$ exp 1', 'Oil $k_{ro}$ exp 2', 'Water $k_{rw}$ exp 2', 'Oil $k_{ro}$ exp 3','Water $k_{rw}$ exp 3', 'Oil $k_{ro}$ sim 3','Water $k_{rw}$ sim 3','BC Oil $k_{ro}$','BC Water $k_{rw}$','Location', 'EastOutside', 'fontsize', 12)
L.Interpreter = 'latex';
xlabel('Water saturation, $S_{w}$ [-]', 'Interpreter', 'latex', 'fontsize', 16)
ylabel('Relative permeability, $k_{r}$ [-]', 'Interpreter', 'latex', 'fontsize', 16)
set(gca, 'YScale', 'log')
axis([0.0 1 0.001 1])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',14)
title(['Core ',int2str(core),' ', resolution_names{resolution}, ' Relative permeability log'], 'interpreter', 'latex', 'fontsize', 14)


figure1 = figure('Position', [100,100,800,500]);
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

msize = 10;

plot((sat_av(1:Nt-1)), kr_g(1:Nt-1), 'o','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerSize',msize)
plot((sat_av(1:Nt-1)), kr_w(1:Nt-1),'d','color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerSize',msize)

plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,3), 'k--','linewidth', 2)
plot(sw_krw_kro_pc(:,1), sw_krw_kro_pc(:,2), 'k-','linewidth', 2)


msize = 5;

L = legend('Oil $k_{ro}$ exp 1', 'Water $k_{rw}$ exp 1', 'Oil $k_{ro}$ exp 2', 'Water $k_{rw}$ exp 2', 'Oil $k_{ro}$ exp 3','Water $k_{rw}$ exp 3', 'Oil $k_{ro}$ sim 3','Water $k_{rw}$ sim 3','BC Oil $k_{ro}$','BC Water $k_{rw}$','Location', 'EastOutside', 'fontsize', 12)
L.Interpreter = 'latex';
xlabel('Water saturation, $S_{w}$ [-]', 'Interpreter', 'latex', 'fontsize', 16)
ylabel('Relative permeability, $k_{r}$ [-]', 'Interpreter', 'latex', 'fontsize', 16)
axis([0.0 1 0.0 0.3])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',14)
title(['Core ',int2str(core),' ', resolution_names{resolution}, ' Relative permeability linear'], 'interpreter', 'latex', 'fontsize', 14)


msize = 3;

aa = Core2_saturations_CZ(:,:,:,1)*1.15;
bb = satMat_sim(:,:,2:31,2);
figure
hold on
plot(aa(:), bb(:),'o', 'color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)

aa = Core2_saturations_CZ(:,:,:,2)*1.15;
bb = satMat_sim(:,:,2:31,3);
plot(aa(:), bb(:),'o', 'color', colours (4,:),'MarkerEdge',colours (4,:),'MarkerFace',colours (4,:),'MarkerSize',msize)

aa = Core2_saturations_CZ(:,:,:,3)*1.15;
bb = satMat_sim(:,:,2:31,4);
plot(aa(:), bb(:),'o', 'color', colours (5,:),'MarkerEdge',colours (5,:),'MarkerFace',colours (5,:),'MarkerSize',msize)

plot(linspace(0, 1, 100), linspace(0, 1, 100), 'k-', 'linewidth', 2)

L = legend('$f_o = 0.05$','$f_o = 0.50$', '$f_o = 1$' ,'Location', 'SouthEast', 'Interpreter', 'latex', 'fontsize', 14);
xlabel('Experiment oil saturation, $S_{o}$ [-]', 'Interpreter', 'latex', 'fontsize', 16)
ylabel('Simulation  oil saturation, $S_{o}$ [-]', 'Interpreter', 'latex', 'fontsize', 16)
axis([0 1 0 1])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',14)
title(['Core ',int2str(core),' ', resolution_names{resolution}, ' voxel saturations'], 'interpreter', 'latex', 'fontsize', 14)



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


x_loc_exp4 = (ds_up_z/2:ds_up_z:(L_tot_exp3)) + offset_mct;

msize = 3;

%%

figure1 = figure('Position', [100,100,800,500]);
hold on

aa = squeeze(nanmean(nanmean(Core2_saturations_CZ(:,:,:,1))))'*1.15;
bb =  squeeze(nanmean(nanmean(satMat_sim(:,:,2:31,2))))';
plot(x_loc_exp4/64.7,aa,'o--', 'color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)
plot(x_loc_exp4/64.7,bb, '-','linewidth', 2, 'color', colours (3,:),'MarkerEdge',colours (3,:),'MarkerFace',colours (3,:),'MarkerSize',msize)

aa = squeeze(nanmean(nanmean(Core2_saturations_CZ(:,:,:,2))))'*1.15;
bb =  squeeze(nanmean(nanmean(satMat_sim(:,:,2:31,3))))';
plot(x_loc_exp4/64.7,aa,'o--', 'color', colours (4,:),'MarkerEdge',colours (4,:),'MarkerFace',colours (4,:),'MarkerSize',msize)
plot(x_loc_exp4/64.7,bb, '-','linewidth', 2, 'color', colours (4,:),'MarkerEdge',colours (4,:),'MarkerFace',colours (3,:),'MarkerSize',msize)


aa = squeeze(nanmean(nanmean(Core2_saturations_CZ(:,:,:,3))))'*1.15;
bb =  squeeze(nanmean(nanmean(satMat_sim(:,:,2:31,4))))';
plot(x_loc_exp4/64.7,aa,'o--', 'color', colours (5,:),'MarkerEdge',colours (5,:),'MarkerFace',colours (5,:),'MarkerSize',msize)
plot(x_loc_exp4/64.7,bb, '-','linewidth', 2, 'color', colours (5,:),'MarkerEdge',colours (5,:),'MarkerFace',colours (3,:),'MarkerSize',msize)


L = legend('Exp $f_o = 0.05$','Sim $f_o = 0.05$', 'Exp $f_o = 0.50$','Sim $f_o = 0.50$','Exp $f_o = 1$','Sim $f_o = 1$','Location', 'NorthEast', 'Interpreter', 'latex', 'fontsize', 12);
xlabel('Distance from core inlet, $x/L$ [-]', 'Interpreter', 'latex', 'fontsize', 16)

ylabel('Oil saturation, $S_{o}$ [-]', 'Interpreter', 'latex', 'fontsize', 14)
axis([0 1 0 1])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',14)
title(['Core ',int2str(core),' ', resolution_names{resolution}, ' slice saturations'], 'interpreter', 'latex', 'fontsize', 14)
ytickformat('%.1f')
xtickformat('%.1f')



sol(:,1) = sat_av_exp;
sol(:,2) = sat_av;
sol(:,7) = sw_exp4(1:3,2);
sol(:,3) = kro_exp4(1:3,2);
sol(:,4) = kr_g';

sol(:,5) = krw_exp4(1:3,2);
sol(:,6) = kr_w';

rel_errors(:,1) = (sol(:,2) - sol(:,1))./sol(:,1)*100;
rel_errors(:,2) = (sol(:,4) - sol(:,3))./sol(:,3)*100;
rel_errors(:,3) = (sol(:,6) - sol(:,5))./sol(:,5)*100;


name = ['Core', int2str(core), '_resolution_',int2str(resolution), '_threshold_', int2str(threshold)];
save(name, 'sol', 'satMat_sim', 'pressMat_sim')

disp('.')
disp('..')
disp('...')
disp('....')
disp('Finished Rel perm calcs')
disp('.')
disp('..')
disp('...')
disp('....')
disp('Wahoo!')

