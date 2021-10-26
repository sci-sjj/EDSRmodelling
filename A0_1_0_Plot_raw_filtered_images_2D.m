%This code plots 2D images of the various raw or filtered images. 
%The image paths and names should be changed to the locations of the images
%stored on the respective machine. 

clc
close all
clearvars

image_path = 'Filtered_images/';
core_name = {'Core1_Subvol1_'; 'Core1_Subvol2_'; 'Core2_Subvol1_'; 'Core2_Subvol2_'};
resolution_name = {'LR_filtered';'LR_bicubic_filtered'; 'HR_filtered'; 'SR'};
titles = {'LR';'Cubic'; 'HR'; 'SR'};
resolution = {225; 675; 675; 675};
slice = [1,2,2,2];


images = cell(4,4);

for iii = 1:4
    
    for jjj = 1:4

    AA = Tiff([image_path, core_name{iii}, resolution_name{jjj}, '.tif'], 'r');
            image_dummy = zeros(resolution{jjj}, resolution{jjj}, resolution{jjj});
            for ii =1:resolution{jjj}
                tt = read(AA);
                image_dummy(:,:,ii) = tt;
                if (ii<resolution{jjj})
                    nextDirectory(AA)
                end
                
            end
            images{iii,jjj} = double(image_dummy);
            
    end
end


%%

image_path = 'Segmented_images/';

core_name = {'Core1_Subvol1_'; 'Core1_Subvol2_'; 'Core2_Subvol1_'; 'Core2_Subvol2_'};
resolution_name = {'LR_filtered';'LR_bicubic_filtered'; 'HR_filtered'; 'SR'};
segmentation_name = {'_99';'_105'; '_111'; '_117';'_123';'_129';'_135'};
titles = {'LR';'LR bicubic'; 'HR'; 'SR'};
resolution = {225; 675; 675; 675};
slice = [1,2,2,2];

for iii = 1:4
    
    for jjj = 1:4
        for kkk = 4
        filename = [image_path, core_name{iii}, resolution_name{jjj},segmentation_name{kkk}, '.raw'];
        images_segmented{iii,jjj,kkk} = double( multibandread(filename,[resolution{jjj},resolution{jjj},resolution{jjj}],'uint8',0,'bsq', 'ieee-le'));
        end
    end
end
%%
axis_labels = {'(a)';'(b)';'(c)';'(d)';'(e)';'(f)';'(g)';'(h)';'(i)';'(j)';'(k)';'(l)';'(m)';'(n)';'(o)';'(p)'}

figure('Position',[100 400 4*230 4*250]);
set(gcf,'color','w')

for jjj = 1:4
        for iii = 1:4
  ha = tight_subplot(iii,jjj,[.02 .02],[.025 .025],[.025 .025])

  set(ha,'visible','off')
        end
end

x11 = 113;
x22 = x11;
size_v = 50;

for jjj = 1:4
    
    for iii = 1:4

        
        p = (iii-1)*4 + jjj

        
        if (jjj <= 1)
          x1 = x11  - size_v;
          x2 = x22  + size_v;  
        else
            x1 = x11*3 - size_v*3;
          x2 = x22*3 + size_v*3;
        end

          
            subplot(ha(p))
            imagesc([x1,x2], [x1,x2], images{iii,jjj}(x1:x2,x1:x2,slice(jjj)))
            colormap gray
            caxis([70 170])
            %colorbar
            if (iii == 1)
            title([titles{jjj}], 'interpreter', 'latex', 'fontsize', 18)
            end
            xlabel(axis_labels{p}, 'interpreter', 'latex', 'fontsize', 18)
            daspect([1 1 1])
%             set(gcf,'color','w')
%             set(gca,'visible','off')
%             axis off
            
    end
end
set(ha,'XTickLabel',''); set(ha,'YTickLabel','')
    hp4 = get(ha(16),'Position')
    h = colorbar('Position', [hp4(1)+hp4(3)+0.02  hp4(2)  0.1  hp4(2)+hp4(3)*2.1]);

    %%
   % titles = {'HR filtered'; 'LR';'LR bicubic'; 'HR'; 'SR'};

    axis_labels = {'(a)';'(b)';'(c)';'(d)';'(e)';'(f)';'(g)';'(h)';'(i)';'(j)';'(k)';'(l)';'(m)';'(n)';'(o)';'(p)';'(q)';'(r)';'(s)';'(t)'}

figure('Position',[100 400 4*250 4*230]);
set(gcf,'color','w')

for jjj = 1:5
        for iii = 1:4
  ha = tight_subplot(iii,jjj,[.02 .01],[.025 .025],[.025 .025])
 
  
  set(ha,'visible','off')
        end
end
 
x11 = 113;
x22 = x11;
size_v = 50;

for jjj = 1:4
    
    for iii = 1:5

        
        p = (jjj-1)*5 + iii

        if (iii <= 1)
          x1 = x11  - size_v;
          x2 = x22  + size_v;  
        else
            x1 = x11*3 - size_v*3;
          x2 = x22*3 + size_v*3;
        end

            if (iii==1)        
                x1 = 1
        x2 = resolution{3}
%         
        
          x1 = x11*3 - size_v*3;
          x2 = x22*3 + size_v*3;

         
            subplot(ha(p))
            imagesc([x1,x2], [x1,x2], images{jjj,3}(x1:x2,x1:x2,slice(jjj)))
            colormap gray
            caxis([70 170])
            else
         x1 = 1
        x2 = resolution{iii-1}
        
        if (iii-1 <= 1)
          x1 = x11  - size_v;
          x2 = x22  + size_v;  
        else
            x1 = x11*3 - size_v*3;
          x2 = x22*3 + size_v*3;
        end
        
            subplot(ha(p))
            imagesc([x1,x2], [x1,x2], images_segmented{jjj,iii-1,4}(x1:x2,x1:x2,slice(jjj)))
            colormap gray
            caxis([0 1])
                
            end
            %colorbar
            if (jjj == 1)
            title([titles{iii}], 'interpreter', 'latex', 'fontsize', 18)
            end
            

            xlabel(axis_labels{p}, 'interpreter', 'latex', 'fontsize', 18)
      daspect([1 1 1])
            %set(gcf,'color','w')
            %set(gca,'visible','off')
            %axis off
            set(gca,'FontSize',18)
    end 
end
set(cb, 'YAxisLocation','right')

set(ha,'XTickLabel',''); set(ha,'YTickLabel','')

    
    %%
axis_labels = {'(a)';'(b)';'(c)';'(d)';' ';'(e)';'(f)';'(g)';'(h)';' ';'(i)';'(j)';'(k)';'(l)';' ';'(m)';'(n)';'(o)';'(p)'}

titles = {'LR';'LR bicubic'; 'HR'; 'SR'};

figure('Position',[100 400 4*250 4*230]);
set(gcf,'color','w')

for jjj = 1:5
        for iii = 1:4
  ha = tight_subplot(iii,jjj,[.02 .01],[.025 .025],[.025 .025])
 
  
  set(ha,'visible','off')
        end
end
 
%x11 = 113;
%x22 = x11;
%size_v = 50;
%x11 = 1;
%x22 = x11;
%size_v = 150;

x11 = 175;
x22 = x11;
size_v = 50;

for jjj = 1:4
    
    for iii = 1:4

        
        p = (jjj-1)*5 + iii

        
%         x1 = 1
%         x2 = resolution{iii}
        
        if (iii <= 1)
          x1 = x11  - size_v;
          x2 = x22  + size_v;  
        else
            x1 = x11*3 - size_v*3;
          x2 = x22*3 + size_v*3;
        end

            
         
            subplot(ha(p))
            imagesc([x1,x2], [x1,x2], images{jjj,iii}(x1:x2,x1:x2,slice(jjj)))
            colormap gray
            caxis([70 170])
            %colorbar
            if (jjj == 1)
            title([titles{iii}], 'interpreter', 'latex', 'fontsize', 18)
            end
            

            xlabel(axis_labels{p}, 'interpreter', 'latex', 'fontsize', 18)
      daspect([1 1 1])
            %set(gcf,'color','w')
            %set(gca,'visible','off')
            %axis off
            set(gca,'FontSize',18)
    end 
end



subplot(ha(10))
colormap gray
caxis([70 170])
cb = colorbar(ha(10),'Position',...
    [0.831646795159122 0.366 0.0379184222321829 0.233]);
text('Units','points','VerticalAlignment','bottom',...
    'HorizontalAlignment','center',...
    'Rotation',90,...
    'String','Greyscale value [-]',...
    'Position',[144.442474226804 -20.6925 0],  'interpreter', 'latex', 'fontsize', 22)
set(cb,'TickLabelInterpreter','latex')
cb.FontSize = 18;
cb.Label.Interpreter = 'latex';
set(cb, 'YAxisLocation','right')

set(ha,'XTickLabel',''); set(ha,'YTickLabel','')