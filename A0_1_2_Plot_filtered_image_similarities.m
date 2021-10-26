%Code to generate image similarity (SSIM) graphs. Make sure results path is
%added and results loaded properly. 

clearvars
close all
clc

addpath('Matlab_results')

colours =   [ 0,0,0; 0    0.4470    0.7410;0.8500    0.3250    0.0980;0.9290 ...
    0.6940    0.1250;0.4940    0.1840    0.5560; 0.4660    0.6740...
    0.1880; 0.3010    0.7450    0.9330; 0.6350    0.0780    0.1840; 0.5 0.5 0.5];

load('Filter_SSIM_results_3D_final')

msize = 8;

figure
hold on

symbol = ['^';'d';'s'; 'o'];

plot(smoothing_lvls1(:,1), similarity1(:,1), '^-','color', colours(1,:), 'markerfacecolor', colours(1,:),'linewidth', 2, 'markersize', msize)
plot(smoothing_lvls1(:,1), similarity1(:,2), '^-','color', colours(2,:), 'markerfacecolor', colours(2,:),'linewidth', 2, 'markersize', msize)

plot(smoothing_lvls1(:,1), similarity2(:,1), 'd-','color', colours(1,:), 'markerfacecolor', colours(1,:), 'linewidth', 2, 'markersize', msize)
plot(smoothing_lvls1(:,1), similarity2(:,2), 'd-','color', colours(2,:), 'markerfacecolor', colours(2,:),'linewidth', 2, 'markersize', msize)

plot(smoothing_lvls1(:,1), similarity3(:,1), 's-','color', colours(1,:), 'markerfacecolor', colours(1,:),'linewidth', 2, 'markersize', msize)
plot(smoothing_lvls1(:,1), similarity3(:,2), 's-', 'color', colours(2,:),'markerfacecolor',colours(2,:),'linewidth', 2, 'markersize', msize)

plot(smoothing_lvls1(:,1), similarity4(:,1), 'o-','color', colours(1,:), 'markerfacecolor', colours(1,:),'linewidth', 2, 'markersize', msize)
plot(smoothing_lvls1(:,1), similarity4(:,2), 'o-', 'color', colours(2,:),'markerfacecolor',colours(2,:),'linewidth', 2, 'markersize', msize)


plot(ones(100,1)*3, linspace(0.74,0.86,100), 'k--','linewidth', 2)
plot(ones(100,1)*6, linspace(0.74,0.856,100), 'k--','linewidth', 2)
plot(ones(100,1)*4.5, linspace(0.74,0.86,100), 'k-', 'linewidth', 2)

legend('LR 2D', 'LR 3D',  'interpreter', 'latex', 'fontsize', 16, 'location', 'NorthWest')
xlabel('Filter strengh [-]', 'Interpreter', 'Latex', 'fontsize', 18)
ylabel('SSIM [-]', 'Interpreter', 'Latex', 'fontsize', 18)
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',16)
grid on
set(gcf,'color','w');
xlim([0 10])

load('Filter_SSIM_results_2D_final')

figure
hold on

plot(smoothing_lvls1(:,1), similarity1(:,1), '^-','color', colours(2,:), 'markerfacecolor', colours(2,:),'linewidth', 2, 'markersize', msize)
plot(smoothing_lvls1(:,2), similarity1(:,2), '^-','color', colours(3,:), 'markerfacecolor', colours(3,:),'linewidth', 2, 'markersize', msize)

plot(smoothing_lvls1(:,1), similarity2(:,1), 'd-','color', colours(2,:), 'markerfacecolor', colours(2,:),'linewidth', 2, 'markersize', msize)
plot(smoothing_lvls1(:,2), similarity2(:,2), 'd-','color', colours(3,:), 'markerfacecolor', colours(3,:),'linewidth', 2, 'markersize', msize)

plot(smoothing_lvls1(:,1), similarity3(:,1), 's-','color', colours(2,:), 'markerfacecolor', colours(2,:),'linewidth', 2, 'markersize', msize)
plot(smoothing_lvls1(:,2), similarity3(:,2),'s-','color', colours(3,:), 'markerfacecolor', colours(3,:),'linewidth', 2, 'markersize', msize)

plot(smoothing_lvls1(:,1), similarity4(:,1), 'o-','color', colours(2,:), 'markerfacecolor', colours(2,:),'linewidth', 2, 'markersize', msize)
plot(smoothing_lvls1(:,2), similarity4(:,2), 'o-','color', colours(3,:), 'markerfacecolor', colours(3,:),'linewidth', 2, 'markersize', msize)


plot(ones(100,1)*3, linspace(0.78,0.9,100), 'k--', 'linewidth', 2)
plot(ones(100,1)*6, linspace(0.78,0.9,100), 'k--', 'linewidth', 2)
plot(ones(100,1)*22, linspace(0.78,0.9, 100), 'k--', 'linewidth', 2)
plot(ones(100,1)*25, linspace(0.78,0.9, 100), 'k--', 'linewidth', 2)

plot(ones(100,1)*4.5, linspace(0.78,0.9, 100), 'k-', 'linewidth', 2)

plot(ones(100,1)*23.5, linspace(0.78,0.9, 100), 'k-', 'linewidth', 2)

legend('LR Bicubic', 'HR',  'interpreter', 'latex', 'fontsize', 16, 'location', 'NorthWest')
xlabel('Filter strengh [-]', 'Interpreter', 'Latex', 'fontsize', 18)
ylabel('SSIM [-]', 'Interpreter', 'Latex', 'fontsize', 18)
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',16)
grid on
set(gcf,'color','w');
ytickformat('%.2f')
