function cell = Load_Multiple_Images_IMACytE( folder,flags,handles)

% Loading a sample and extracting meta-data from its location and
% high-dimensional vector
%   -folder: The folder that includes all the images

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox
persistent tiles

temp=strsplit(folder,'\');
cell.name=temp{end};

fnam=dir([folder '\*mask*']);
% fnam=dir([folder '\*_mask.tiff']);

%% Concatenate images according to the tiles.txt file
% if length(fnam)>1
%     try 
%         tiles=load([folder '\tiles.txt']);
%     catch
%         prompt={'Orientation of images, in order to create a montaged image'};
%         dlg_title=['Input (sum of ' num2str(length(fnam)) ' images)'];
%         num_lines=2;
%         defaultan={num2str(tiles)};
%         x=inputdlg(prompt,dlg_title,num_lines,defaultan);
%         tiles=str2num(x{:}); 
%     end
% else
%     tiles=0;
% end

prev=0;
mask_id_val=[];
details=1:(length(fnam)-1);
for i=1:length(fnam)
    mask{i}=imread([fnam(i).folder '\' fnam(i).name]);
%     mask{i}=bwlabel(rgb2gray(imread([fnam(i).folder '\' fnam(i).name])));
    mask{i}(mask{i}~=0)= mask{i}(mask{i}~=0)+prev;
%     prev=prev+length(unique(mask{i}))-1;
%% Load the cell segmentation mask
% cell.mask_cell=my_montage_img(fnam(i),tiles,1); 
% cell.cell_borders = imdilate(cell.mask_cell,ones(3,3)) > imerode(cell.mask_cell,ones(3,3));


%% Extract meta-data from the morphology of the cells
bw_props=regionprops(mask{i},'Centroid','PixelIdxlist','Eccentricity','Area','MajorAxisLength','MinorAxisLength','Orientation','Perimeter');   % I could get MeanIntensity also for regionprops
bw_props_=struct2cell(bw_props);
bw_props_names=fieldnames(bw_props);
cell.idx(prev+1:max(mask{i}(:)))=bw_props_(contains(bw_props_names,'PixelIdxList'),prev+1:max(mask{i}(:)));
cell.cells_centre(prev+1:max(mask{i}(:)),:)=vertcat(bw_props(prev+1:max(mask{i}(:))).Centroid);
mask_id_val(prev+1:max(mask{i}(:)),1)=i;
prev=prev+length(unique(mask{i}))-1;

end
%% Check for segemented tissue parts
segement_value=getappdata(handles.figure1,'segment_value');
segment_dir=dir([folder '\*Tissue_segmented.tiff']);
if ~isempty(segment_dir)
    segment=imread([segment_dir(1).folder '\' segment_dir(1).name]);
    if segement_value ==0
        segement_value=listdlg('ListString',{'Stroma','Tumour','Empty'});
        setappdata(handles.figure1,'segment_value',segement_value);
    end
    temp=ismember(segment,segement_value);
    temp=temp.*cell.mask_cell;
    temp3=unique(temp)+1;
    temp4=ones(1,max(temp3));
    temp4(1)=0;
    for i=1:length(temp3)
        temp4(temp3(i))=i;
    end
    cell.mask_cell=temp4(temp+1)-1;
end

fnam=dir([folder '\*ome.tiff']);

%% Convert images to thresholded ones
if flags(1)
    try
        if flags(2)
            [cell.high_dim_img,cell.cell_markers] = my_montage_txt2(fnam,tiles);
            cell.high_dim_img=load_thresholds(folder,cell.high_dim_img);
        else
%             temp=load_thresholds_full(folder);
            [cell.high_dim_img,cell.cell_markers]=load_thresholds_all_markers(folder);
        end
    catch
        warndlg(['There is no threshold file in folder: ' folder],'Error');
    end
else
    if flags(2)
        [cell.high_dim_img,cell.cell_markers] = my_montage_txt2(fnam,tiles,1);
    else
        [cell.high_dim_img,cell.cell_markers] = my_montage_txt2(fnam,tiles,0);
    end
end

%% Load their high-dimensional values and extract one vector per cell

r_high=reshape(cell.high_dim_img,[],size(cell.high_dim_img,3));
for i=1:length(cell.idx)
    r_vecc=r_high(cell.idx{i},:);
    cell.data(i,1:size(r_vecc,2))=mean(r_vecc);   % Average of the pixels/ for integrated intensity use sum(r_vecc)
end

cell.cell_markers=[cell.cell_markers  'Mask_id'];
cell.data=[cell.data mask_id_val];
% cell.cell_markers=[cell.cell_markers bw_props_names([1 3:6 8])'];
% cell.data=[cell.data cell2mat( bw_props_([1 3:6 8],:))'];

temp_mask=mask{1};
pbaspect([size(temp_mask,2) size(temp_mask,1) 1])
for i=1:length(details)
    temp_mask(mask{details(i)}~=0)=mask{details(i)}(mask{details(i)}~=0);
end
cell.mask_all=mask;
cell.mask_cell=temp_mask;
cell.cell_borders = imdilate(cell.mask_cell,ones(3,3)) > imerode(cell.mask_cell,ones(3,3));

end

