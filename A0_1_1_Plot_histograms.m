%This code plots histograms of the greyscale values from the raw or filtered images. Note
%the histogram file is very large, so is not stored on this GitHub repo, but can
%be genrated using 'A0_0_2_Generate histogram_data.m' and the appropriate image data. 
%You need to add the results path and load the histogram data. 

clc
close all
clearvars

addpath('Matlab_results')
load('Raw_histograms_3D_filtered')

colours =   [ 0,0,0; 0    0.4470    0.7410;0.8500    0.3250    0.0980;0.9290 ...
    0.6940    0.1250;0.4940    0.1840    0.5560; 0.4660    0.6740...
    0.1880; 0.3010    0.7450    0.9330; 0.6350    0.0780    0.1840; 0.5 0.5 0.5];
%%
n = 1001;
lim1 = 50;
lim2 = 200;
edges = linspace(lim1,lim2,n);

image = 1;
figure
%figure('Position',[100 400 1000 1000]);
hold all
h = histogram(image_vec{image,1},edges, 'DisplayStyle','stairs', 'Normalization', 'probability','linewidth', 2,'EdgeColor', colours(1,:));
h = histogram(image_vec{image,2},edges, 'DisplayStyle','stairs', 'Normalization', 'probability','linewidth', 2,'EdgeColor', colours(2,:));
h = histogram(image_vec{image,3},edges, 'DisplayStyle','stairs','Normalization', 'probability', 'linewidth', 2,'EdgeColor', colours(3,:));
h = histogram(image_vec{image,4},edges, 'DisplayStyle','stairs', 'Normalization', 'probability','linewidth', 2, 'FaceAlpha',0,'EdgeColor', colours(4,:));
plot(ones(100,1)*117, linspace(0,0.2,100), 'k--', 'linewidth', 2)
set(gcf,'color','w')
legend('LR','Cubic', 'HR', 'SR','Grain-pore minima', 'interpreter', 'latex', 'fontsize', 18, 'location', 'NorthWest')
xlabel('Greyscale value [-]', 'Interpreter', 'Latex', 'fontsize', 18)
ylabel('Probability [-]', 'Interpreter', 'Latex', 'fontsize', 18)
set(gca,'TickLabelInterpreter','latex')
set(gca,'Fontsize',18)
grid on
set(gcf,'color','w');
ytickformat('%.2f')