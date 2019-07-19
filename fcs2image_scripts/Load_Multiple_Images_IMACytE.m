function cell = Load_Multiple_Images_IMACytE( folder)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox
persistent tiles

temp=strsplit(folder,'\');
cell.name=temp{end};

fnam=dir([folder '\*_mask.tiff']);

if length(fnam)>1
    try 
        tiles=load([folder '\tiles.txt']);
    catch
        prompt={'Orientation of images, in order to create a montaged image'};
        dlg_title=['Input (sum of ' num2str(length(fnam)) ' images)'];
        num_lines=2;
        defaultan={num2str(tiles)};
        x=inputdlg(prompt,dlg_title,num_lines,defaultan);
        tiles=str2num(x{:}); 
    end
else
    tiles=0;
end

cell.mask_cell=my_montage_img(fnam,tiles,1); 
cell.cell_borders = imdilate(cell.mask_cell,ones(3,3)) > imerode(cell.mask_cell,ones(3,3));

bw_props=regionprops(cell.mask_cell,'Centroid','PixelIdxlist','Eccentricity','Area','MajorAxisLength','MinorAxisLength','Orientation','Perimeter');   % I could get MeanIntensity also for regionprops
bw_props_=struct2cell(bw_props);
bw_props_names=fieldnames(bw_props);
cell.idx=bw_props_(contains(bw_props_names,'PixelIdxList'),:);
cell.cells_centre=vertcat(bw_props.Centroid);


% fnam=dir([folder '\*.txt']);
% fnam=fnam(~cellfun(@(x) isequal(x,'tiles.txt'), {fnam.name}));
% [cell.high_dim_img,cell.cell_markers] = my_montage_txt(fnam,tiles);

fnam=dir([folder '\*.ome.tiff']);

[cell.high_dim_img,cell.cell_markers] = my_montage_txt2(fnam,tiles);

r_high=reshape(cell.high_dim_img,[],size(cell.high_dim_img,3));
for i=1:length(cell.idx)
    r_vecc=r_high(cell.idx{i},:);
    cell.data(i,1:size(r_vecc,2))=mean(r_vecc);   % Average of the pixels/ for integrated intensity use sum(r_vecc)
end

cell.cell_markers=[cell.cell_markers bw_props_names([1 3:6 8])'];
cell.data=[cell.data cell2mat( bw_props_([1 3:6 8],:))'];
% for i=1:size(cell.high_dim_img,3)
%     tempor=regionprops(cell.mask_cell,cell.high_dim_img(:,:,i),'PixelValues');
%     cell.data(i,:)=arrayfun(@(x) median(x.PixelValues),tempor);
% end

% temo=1:length(cell.idx);
% temo=[temo' cell.data ones(length(cell.idx),1)*count];
% temp_markers=[ 'Cell_id'  'Image_id' cell.cell_markers'];
% fca_writefcs([folder '\avg_celled_image.fcs'],temo,temp_markers,temp_markers);
% cell.id_data=temo;

% cell.neighlist=neighlist_creation(cell.mask_cell);
end
