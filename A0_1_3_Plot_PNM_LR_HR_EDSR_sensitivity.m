% This code plots the PNM results for the LR/Cubic/HR/EDSR subvolumes in
% core 1 and core 2, against experimental measured from Jackson et al. 2020,
% Jackson, S.J., Lin, Q. and Krevor, S. 2020. Representative Elementary Volumes, 
% Hysteresis, and Heterogeneity in Multiphase Flow from the Pore to Continuum Scale. 
% Water Resources Research, 56(6), e2019WR026396. 

close all
clearvars
clc

addpath('Matlab_results')
addpath('Exp_data')

load('Results_PNM_LR_HR_SR_sensitivity_all.mat')
load('kro_krw_so_soconn_min_mean_max_exp3.txt')
load('kro_krw_so_soconn_min_mean_max_exp2.txt')
load('kro_krw_so_soconn_min_mean_max_exp4.txt')

s1 = importdata('MICP.txt');

colours =   [ 0,0,0; 0    0.4470    0.7410;0.8500    0.3250    0.0980;0.9290 ...
    0.6940    0.1250;0.4940    0.1840    0.5560; 0.4660    0.6740...
    0.1880; 0.3010    0.7450    0.9330; 0.6350    0.0780    0.1840; 0.5 0.5 0.5];

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


IFT_mercury = 0.485;
IFT_meso = 0.051;

s1(:,2) = s1(:,2)*6.89476*IFT_meso/IFT_mercury;

nw_coeff = 4.6;
w_coeff =4.4;
kro_1 = 0.8;
krw_1 = 1;
swirr = 0.08;

sw_krw_kro_pc(:,1) = linspace(swirr,1, 100)';
sw_krw_kro_pc(:,2) = krw_1.*((sw_krw_kro_pc(:,1)-swirr)/(1-swirr)).^w_coeff;
sw_krw_kro_pc(:,3) = kro_1.*(1-((sw_krw_kro_pc(:,1)-swirr)/(1-swirr))).^nw_coeff;


%%
%non-wetting rel perms

for subvol = 1:4

%subvol =3;

figure
hold on

plot(sw_exp3(1:2,2),kro_exp3(1:2,2), 'ko', 'linewidth', 2, 'markersize', 10 , 'markerfacecolor', 'k')
plot(sw_krw_kro_pc(:,1),sw_krw_kro_pc(:,3), 'k--','markerfacecolor', 'k', 'linewidth', 2)

resolution = 1;
plot(kr{subvol, 1, resolution}(:,1), kr{subvol, 1, resolution}(:,3), 'k-', 'linewidth', 2)

resolution = 2;
plot(kr{subvol, 1, resolution}(:,1), kr{subvol, 1, resolution}(:,3), 'color', colours (2,:), 'linewidth', 2)

resolution = 3;
plot(kr{subvol, 1, resolution}(:,1), kr{subvol, 1, resolution}(:,3),'color', colours (4,:), 'linewidth', 2)

resolution = 4;
plot(kr{subvol, 1, resolution}(:,1), kr{subvol, 1, resolution}(:,3),'color', colours (3,:), 'linewidth', 2)


for segmentation = 2:7
plot(kr{subvol, segmentation, 1}(:,1), kr{subvol, segmentation, 1}(:,3), 'k-', 'linewidth', 2)
plot(kr{subvol, segmentation, 2}(:,1), kr{subvol, segmentation, 2}(:,3), '-','color', colours (2,:),'linewidth', 2)
plot(kr{subvol, segmentation, 3}(:,1), kr{subvol, segmentation, 3}(:,3), '-','color',colours (4,:), 'linewidth', 2)
plot(kr{subvol, segmentation, 4}(:,1), kr{subvol, segmentation, 4}(:,3), '-','color',colours (3,:), 'linewidth', 2)
plot(sw_exp4(1:3,2),kro_exp4(1:3,2), 'ko','linewidth', 2, 'markersize', 10 , 'markerfacecolor', 'k')

end


xlabel('Water saturation, $S_w$ [-]', 'Interpreter', 'Latex', 'Fontsize', 16)
ylabel('NW relative permeability, $K_{r,nw}$ [-]', 'Interpreter', 'Latex', 'Fontsize', 16)
legend('Exp $K_r$','BC exp fit', 'LR','Cubic', 'HR', 'SR', 'Interpreter', 'latex','Fontsize', 18, 'location', 'NorthEast')
set(gca,'FontSize',18)
set(gca,'TickLabelInterpreter','Latex')
set(gcf,'color','w');
grid on
ytickformat('%.1f')
xtickformat('%.1f')
%title('Non-Wetting relative permeability', 'Interpreter', 'Latex', 'Fontsize', 16)
end
%%
%Wetting relative permeability

for subvol = 1:4

figure
hold on

plot(sw_exp3(1:2,2),krw_exp3(1:2,2), 'ko', 'linewidth', 2, 'markersize', 10 , 'markerfacecolor', 'k')
plot(sw_krw_kro_pc(:,1),sw_krw_kro_pc(:,2), 'k--','markerfacecolor', 'k', 'linewidth', 2)

resolution = 1;
plot(kr{subvol, 1, resolution}(:,1), kr{subvol, 1, resolution}(:,2), 'k-', 'color', colours (1,:) ,'linewidth', 2)

resolution = 2;
plot(kr{subvol, 1, resolution}(:,1), kr{subvol, 1, resolution}(:,2), 'b-', 'color', colours (2,:), 'linewidth', 2)

resolution = 3;
plot(kr{subvol, 1, resolution}(:,1), kr{subvol, 1, resolution}(:,2), 'r-', 'color', colours (4,:), 'linewidth', 2)
% 
 resolution = 4;
 plot(kr{subvol, 1, resolution}(:,1), kr{subvol, 1, resolution}(:,2), 'g-', 'color', colours (3,:), 'linewidth', 2)


for segmentation = 2:7
plot(kr{subvol, segmentation, 1}(:,1), kr{subvol, segmentation, 1}(:,2), 'k-', 'color', colours (1,:), 'linewidth', 2)
plot(kr{subvol, segmentation, 2}(:,1), kr{subvol, segmentation, 2}(:,2), 'b-', 'color', colours (2,:), 'linewidth', 2)
plot(kr{subvol, segmentation, 3}(:,1), kr{subvol, segmentation, 3}(:,2), 'r-', 'color', colours (4,:), 'linewidth', 2)
plot(kr{subvol, segmentation, 4}(:,1), kr{subvol, segmentation, 4}(:,2), 'g-', 'color', colours (3,:), 'linewidth', 2)

end

plot(sw_exp3(1:2,2),krw_exp3(1:2,2), 'ko','linewidth', 2, 'markersize', 10 , 'markerfacecolor', 'k')
plot(sw_exp4(1:3,2),krw_exp4(1:3,2), 'ko', 'linewidth', 2, 'markersize', 10 , 'markerfacecolor', 'k')

xlabel('Water saturation, $S_w$ [-]', 'Interpreter', 'Latex', 'Fontsize', 16)
ylabel('W relative permeability, $K_{r,w}$ [-]', 'Interpreter', 'Latex', 'Fontsize', 16)
legend('Exp $K_r$','BC exp fit', 'LR','Cubic', 'HR', 'SR', 'Interpreter', 'latex','Fontsize', 18, 'location', 'NorthWest')
set(gca,'FontSize',18)
set(gca,'TickLabelInterpreter','Latex')
set(gcf,'color','w');
grid on
ytickformat('%.1f')
xtickformat('%.1f')
%title('Wetting relative permeability', 'Interpreter', 'Latex', 'Fontsize', 16)
end

%%
for subvol = 1:4
figure
hold on



plot(s1(:,1), s1(:,2), 'ko-', 'markerfacecolor', 'k','linewidth', 2)

resolution = 1;
plot(pc{subvol, 1, resolution}(:,1), pc{subvol, 1, resolution}(:,2)/1000, 'k-', 'color', colours (1,:), 'linewidth', 2)

resolution = 2;
plot(pc{subvol, 1, resolution}(:,1), pc{subvol, 1, resolution}(:,2)/1000, 'b-', 'color', colours (2,:), 'linewidth', 2)

resolution = 3;
plot(pc{subvol, 1, resolution}(:,1), pc{subvol, 1, resolution}(:,2)/1000, 'r-', 'color', colours (4,:), 'linewidth', 2)
resolution = 4;

plot(pc{subvol, 1, resolution}(:,1), pc{subvol, 1, resolution}(:,2)/1000, 'g-', 'color', colours (3,:), 'linewidth', 2)


for segmentation = 1:7
plot(pc{subvol, segmentation, 1}(:,1), pc{subvol, segmentation, 1}(:,2)/1000, 'k-', 'color', colours (1,:), 'linewidth', 2)
plot(pc{subvol, segmentation, 2}(:,1), pc{subvol, segmentation, 2}(:,2)/1000, 'b-', 'color', colours (2,:), 'linewidth', 2)
plot(pc{subvol, segmentation, 3}(:,1), pc{subvol, segmentation, 3}(:,2)/1000, 'r-', 'color', colours (4,:), 'linewidth', 2)
plot(pc{subvol, segmentation, 4}(:,1), pc{subvol, segmentation, 4}(:,2)/1000, 'g-', 'color', colours (3,:), 'linewidth', 2)

end
plot(s1(:,1), s1(:,2), 'ko-', 'markerfacecolor', 'k','linewidth', 2)


axis([0 1 0 10])
xlabel('Wetting saturation, $S_w$ [-]','interpreter','latex', 'fontsize', 16)
ylabel('Capillary pressure, $P_c$ [kPa]','interpreter','latex', 'fontsize', 16)
legend('MICP', 'LR','Cubic', 'HR','SR','Interpreter', 'latex', 'fontsize', 18,'location', 'NorthEast')

L.Interpreter = 'latex';
set(gca,'FontSize',18)
set(gca,'TickLabelInterpreter','Latex')
set(gcf,'color','w');
grid on
ytickformat('%.0f')
xtickformat('%.1f')
end
%title('Capillary pressure', 'Interpreter', 'Latex', 'Fontsize', 16)
%%

%%
%%
%xx = linspace( min(min(perm_new))*0.95, max(max(perm_new))*1.05, 100);

figure('Position',[100 400 600 475]); 
hold on
symbol = ['^';'d';'s'; 'o'];
i = 1;
for i = 1:4
scatter(kabs(i,:,3), kabs(i,:,1),140, colours(1,:),symbol(i), 'filled')
scatter(kabs(i,:,3), kabs(i,:,2),140, colours(2,:),symbol(i),  'filled')
scatter(kabs(i,:,3), kabs(i,:,4),140, colours(3,:),symbol(i),  'filled')
plot(linspace(0, 12000, 100), linspace(0, 12000, 100),'k--', 'linewidth', 3)
%plot(xx,xx, 'k-', 'linewidth', 2)
end
xlabel('HR permeability [mD]', 'interpreter','latex', 'fontsize', 16)
ylabel('LR/Cubic/SR permeability [mD]','interpreter','latex', 'fontsize', 16)

legend('LR','Cubic','SR','1:1 line', 'Interpreter', 'latex', 'location', 'NorthWest' ,'Fontsize', 18)
xlim([0 5000])
ylim([0 10000])
%xlim([xx(1), xx(end)])
%ylim([xx(1), xx(end)])
L.Interpreter = 'latex';
set(gca,'FontSize',18)
set(gca,'TickLabelInterpreter','Latex')
set(gcf,'color','w');
grid on

%%

figure('Position',[100 400 600 475]); 
hold on
symbol = ['^';'d';'s'; 'o'];
for i = 1:4
scatter(phi_pnm(i,:,3), phi_pnm(i,:,1),140, colours(1,:),symbol(i), 'filled')
scatter(phi_pnm(i,:,3), phi_pnm(i,:,2),140, colours(2,:),symbol(i), 'filled')
scatter(phi_pnm(i,:,3), phi_pnm(i,:,4),140, colours(3,:),symbol(i), 'filled')
plot(linspace(0, 1, 100), linspace(0, 1, 100),'k--', 'linewidth', 2)
%plot(xx,xx, 'k-', 'linewidth', 2)
end
xlabel('HR porosity [-]', 'interpreter','latex', 'fontsize', 16)
ylabel('LR/Cubic/SR porosity [-]','interpreter','latex', 'fontsize', 16)

legend('LR','Cubic','SR','1:1 line', 'Interpreter', 'latex', 'location', 'NorthWest' ,'Fontsize', 18)
xlim([0.17 0.25])
ylim([0.11 0.28])
%xlim([xx(1), xx(end)])
%ylim([xx(1), xx(end)])
L.Interpreter = 'latex';
set(gca,'FontSize',18)
set(gca,'TickLabelInterpreter','Latex')
set(gcf,'color','w');
grid on
ytickformat('%.2f')
xtickformat('%.2f')

%title('Permeability comparison', 'Interpreter', 'Latex', 'Fontsize', 18)


%%
figure('Position',[100 400 600 475]); 
hold on

for i = 1:4
stat = 1;
stat2 = 2;

subvol = i;

x1 = 0.2;
x2 = 0.7;

for ii = 1:7
scatter(network_stats{subvol,ii,3}(stat)./network_stats{subvol,ii,3}(stat2), network_stats{subvol,ii,1}(stat)./network_stats{subvol,ii,1}(stat2),140,colours(1,:),symbol(i), 'filled')
scatter(network_stats{subvol,ii,3}(stat)./network_stats{subvol,ii,3}(stat2), network_stats{subvol,ii,2}(stat)./network_stats{subvol,ii,2}(stat2),140,colours(2,:),symbol(i), 'filled')
scatter(network_stats{subvol,ii,3}(stat)./network_stats{subvol,ii,3}(stat2), network_stats{subvol,ii,4}(stat)./network_stats{subvol,ii,4}(stat2),140,colours(3,:),symbol(i), 'filled')
plot(linspace(x1,x2,100), linspace(x1,x2,100), 'k--', 'linewidth', 2)
end
end
xlabel('HR pores:throats ratio [-]', 'interpreter','latex', 'fontsize', 16)
ylabel('LR/Cubic/SR pores:throats ratio [-]','interpreter','latex', 'fontsize', 16)

legend('LR','Cubic', 'SR','1:1 line', 'Interpreter', 'latex', 'location', 'SouthEast' ,'Fontsize', 18)

L.Interpreter = 'latex';
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','Latex')
set(gcf,'color','w');
grid on


%%

figure('Position',[100 400 600 475]); 
hold on

for i = 1:4
stat = 3;

subvol = i;

x1 = 3;
x2 = 7;

for ii = 1:7
scatter(network_stats{subvol,ii,3}(stat), network_stats{subvol,ii,1}(stat),140,colours(1,:),symbol(i), 'filled')
scatter(network_stats{subvol,ii,3}(stat), network_stats{subvol,ii,2}(stat),140,colours(2,:),symbol(i),'filled')
scatter(network_stats{subvol,ii,3}(stat), network_stats{subvol,ii,4}(stat),140,colours(3,:),symbol(i), 'filled')
plot(linspace(x1,x2,100), linspace(x1,x2,100), 'k--', 'linewidth', 2)
end
end
xlabel('HR coordination number [-]', 'interpreter','latex', 'fontsize', 16)
ylabel('LR/Cubic/SR coordination number [-]','interpreter','latex', 'fontsize', 16)

legend('LR','Cubic','SR','1:1 line', 'Interpreter', 'latex', 'location', 'SouthEast' ,'Fontsize', 18)
xlim([3 6])
ylim([2 7])
L.Interpreter = 'latex';
set(gca,'FontSize',18)
set(gca,'TickLabelInterpreter','Latex')
set(gcf,'color','w');
grid on
xtickformat('%.1f')
ytickformat('%.1f')

%%

figure('Position',[100 400 600 475]); 
hold on

for i = 1:4
stat = 10;

subvol = i;

x1 = 0;
x2 = 100;

for ii = 1:7
scatter(network_stats{subvol,ii,3}(stat), network_stats{subvol,ii,1}(stat),140,colours(1,:),symbol(i), 'filled')
scatter(network_stats{subvol,ii,3}(stat), network_stats{subvol,ii,2}(stat),140,colours(2,:),symbol(i),'filled')
scatter(network_stats{subvol,ii,3}(stat), network_stats{subvol,ii,4}(stat),140,colours(3,:),symbol(i), 'filled')
plot(linspace(x1,x2,100), linspace(x1,x2,100), 'k--', 'linewidth', 2)
end


end
xlabel('HR formation factor [-]', 'interpreter','latex', 'fontsize', 16)
ylabel('LR/Cubic/SR formation factor [-]','interpreter','latex', 'fontsize', 16)

legend('LR','Cubic','SR','1:1 line', 'Interpreter', 'latex', 'location', 'NorthWest' ,'Fontsize', 18)
xlim([8 40 ])
ylim([7 100])
L.Interpreter = 'latex';
set(gca,'FontSize',18)
set(gca,'TickLabelInterpreter','Latex')
set(gcf,'color','w');
grid on

%%

figure('Position',[100 400 600 475]); 
hold on

for i = 1:4
stat = 9;

subvol = i;

x1 = 0;
x2 = 100;

for ii = 1:7
scatter(network_stats{subvol,ii,3}(stat), network_stats{subvol,ii,1}(stat),140,colours(1,:),symbol(i), 'filled')
scatter(network_stats{subvol,ii,3}(stat), network_stats{subvol,ii,2}(stat),140,colours(2,:),symbol(i), 'filled')
scatter(network_stats{subvol,ii,3}(stat), network_stats{subvol,ii,4}(stat),140,colours(3,:),symbol(i), 'filled')
plot(linspace(x1,x2,100), linspace(x1,x2,100), 'k--', 'linewidth', 2)
end


end
xlabel('HR Median throat length to radius ratio [-]', 'interpreter','latex', 'fontsize', 16)
ylabel('LR/Cubic/SR Median throat length to radius ratio [-]','interpreter','latex', 'fontsize', 16)

legend('LR','Cubic','SR','1:1 line', 'Interpreter', 'latex', 'location', 'NorthWest' ,'Fontsize', 18)
%xlim([8 40 ])
%ylim([7 100])
L.Interpreter = 'latex';
set(gca,'FontSize',16)
set(gca,'TickLabelInterpreter','Latex')
set(gcf,'color','w');
grid on

%%


%             if (i == 1)
%                 out=regexp(tline,'Number of pores','match');
%             elseif (i == 2)
%                 out=regexp(tline,'Number of throats','match');
%             elseif (i == 3)
%                 out=regexp(tline,'Average connection number','match');
%             elseif (i == 4)
%                 out=regexp(tline,'Number of connections to inlet','match');
%             elseif (i == 5)
%                 out=regexp(tline,'Number of connections to outlet','match');
%             elseif (i == 6)
%                 out=regexp(tline,'Number of physically isolated elements','match'); 
%             elseif (i == 7)
%                 out=regexp(tline,'Number of triangular shaped elements','match');
%             elseif (i == 8)
%                 out=regexp(tline,'Number of square shaped elements','match');
%             elseif (i == 9)
%                 out=regexp(tline,'Median throat length to radius ratio','match');
%             elseif (i == 10)
%                 out=regexp(tline,'Formation factor','match');
%             end

