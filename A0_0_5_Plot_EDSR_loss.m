%This code plots the EDSR training loss and PSNR

clc
clearvars
close all

addpath('Functions')
addpath('EDSR_training_results')

load('Epoch_PSNR_Loss_training_testing.txt')

colours =   [ 0    0.4470    0.7410;0.8500    0.3250    0.0980;0.9290 ...
    0.6940    0.1250;0.4940    0.1840    0.5560; 0.4660    0.6740...
    0.1880; 0.3010    0.7450    0.9330; 0.6350    0.0780    0.1840];


msize = 6;

figure
hold on

plot(Epoch_PSNR_Loss_training_testing(:,1),Epoch_PSNR_Loss_training_testing(:,2), 'o-', 'color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize, 'linewidth', 2)
plot(Epoch_PSNR_Loss_training_testing(:,1),Epoch_PSNR_Loss_training_testing(:,3), 'd-', 'color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize, 'linewidth', 2)

L = legend('Training', 'Testing','Location', 'SouthEast', 'Interpreter', 'latex', 'fontsize', 18);
xlabel('Epoch \# [-]', 'Interpreter', 'latex', 'fontsize', 18)

ylabel('PSNR [-]', 'Interpreter', 'latex', 'fontsize', 18)
%axis([0 1 0 1])
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)
ytickformat('%.0f')
xtickformat('%.0f')
grid on


figure
hold on

plot(Epoch_PSNR_Loss_training_testing(:,1),Epoch_PSNR_Loss_training_testing(:,4), 'o-', 'color', colours (1,:),'MarkerEdge',colours (1,:),'MarkerFace',colours (1,:),'MarkerSize',msize, 'linewidth', 2)
plot(Epoch_PSNR_Loss_training_testing(:,1),Epoch_PSNR_Loss_training_testing(:,5), 'd-', 'color', colours (2,:),'MarkerEdge',colours (2,:),'MarkerFace',colours (2,:),'MarkerSize',msize, 'linewidth', 2)

L = legend('Training', 'Testing','Location', 'NorthEast', 'Interpreter', 'latex', 'fontsize', 18);
xlabel('Epoch \# [-]', 'Interpreter', 'latex', 'fontsize', 18)
ylabel('$L_1$ Loss [-]', 'Interpreter', 'latex', 'fontsize', 18)
set(gcf,'color','w');
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',20)
ytickformat('%.2f')
xtickformat('%.0f')
grid on