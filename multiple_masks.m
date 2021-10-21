folder='E:\PhD\Data\Test multiple masks over one image\other masks\';

files_=dir([folder '*color.tif']);

prev=0;
for i=1:length(files_)
    mask{i}=bwlabel(rgb2gray(imread([files_(i).folder '\' files_(i).name])));
    mask{i}(mask{i}~=0)= mask{i}(mask{i}~=0)+prev;
    prev=prev+length(unique(mask{i}))-1;
    figure; imshow(label2rgb(mask{i},'jet',[0 0 0],'shuffle'));
end

%% Total overlay DNA+Myeloid+T cells
basic_layer=2;
details=[4 3];
temp_mask=mask{basic_layer};
% Each cell type in a seperate image
figure('units','normalized','outerposition',[0 0 1 1],'visible','off'); image(label2rgb(mask{basic_layer},'jet',[0 0 0],'shuffle'));
pbaspect([size(temp_mask,2) size(temp_mask,1) 1])
print(gcf,['E:\PhD\Data\Test multiple masks over one image\' files_(basic_layer).name(1:end-10) '.png'],'-dpng') ; close(gcf);

name_file=[files_(basic_layer).name(1:end-10)];
for i=1:length(details)
temp_mask(mask{details(i)}~=0)=mask{details(i)}(mask{details(i)}~=0);
name_file=[name_file ' ' files_(details(i)).name(1:end-10)];

figure('units','normalized','outerposition',[0 0 1 1],'visible','off'); image(label2rgb(mask{details(i)},'jet',[0 0 0],'shuffle'));
pbaspect([size(temp_mask,2) size(temp_mask,1) 1])
print(gcf,['E:\PhD\Data\Test multiple masks over one image\' files_(details(i)).name(1:end-10) '.png'],'-dpng') ; close(gcf);
end
% The different types in one image
figure('units','normalized','outerposition',[0 0 1 1],'visible','off'); image(label2rgb(temp_mask,'jet',[0 0 0],'shuffle'));
pbaspect([size(temp_mask,2) size(temp_mask,1) 1])
print(gcf,['E:\PhD\Data\Test multiple masks over one image\Overlaid_' name_file '.png'],'-dpng') ; close(gcf);

% The different types in one image with different transaprencies
figure('units','normalized','outerposition',[0 0 1 1],'visible','off'); image(label2rgb(mask{basic_layer},'jet',[0 0 0],'shuffle'));
for i=1:length(details)
    hold on
    image(label2rgb(mask{details(i)},'jet',[0 0 0],'shuffle'),'AlphaData',0.85 - min((i-1)/length(details),0.7));
    hold off
end
pbaspect([size(temp_mask,2) size(temp_mask,1) 1])
print(gcf,['E:\PhD\Data\Test multiple masks over one image\Overlaid_diff_transparencies_' name_file '.png'],'-dpng') ; close(gcf);
%% Overlay in one image
figure; 
subplot(2,2,1); title(files_(basic_layer).name(1:end-10),'Interpreter','None'); 
imshow(label2rgb(mask{basic_layer},'jet',[0 0 0],'shuffle'));
print(gcf,['E:\PhD\Data\Test multiple masks over one image\' files_(basic_layer).name(1:end-10) '.png'],'-dpng') ; close(gcf);

subplot(2,2,2); 
title(files_(details).name,'Interpreter','None'); imshow(label2rgb(mask{details},'jet',[0 0 0],'shuffle'));

figure;
subplot(2,2,3); 
title([files_(basic_layer).name ' + ' files_(details).name],'Interpreter','None'); imshow(label2rgb(temp_mask,'jet',[0 0 0],'shuffle'));
print(gcf,['E:\PhD\Data\Test multiple masks over one image\' files_(basic_layer).name(1:end-10) '.png'],'-dpng') ; close(gcf);

figure;
subplot(2,2,4); 
title([files_(basic_layer).name ' + ' files_(details).name ],'Interpreter','None');
image(label2rgb(mask{basic_layer},'jet',[0 0 0],'shuffle'));
hold on
image(label2rgb(mask{details},'jet',[0 0 0],'shuffle'),'AlphaData',0.8);
hold off
%% Different saturation