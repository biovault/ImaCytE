 function cell = Load_Only_masks
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

temp=strsplit(fnam,'\');
temp=temp{end};
temp=strsplit(temp,'.tiff');
cell.name=temp{1};
cell.mask_cell=imread(fnam); 
cell.cell_borders = imdilate(cell.mask_cell,ones(3,3)) > imerode(cell.mask_cell,ones(3,3));
%%
bw_props=regionprops(cell.mask_cell,'Centroid','PixelIdxlist');   % I could get MeanIntensity also for regionprops
empty_idx=find(cellfun('isempty',{bw_props(:).PixelIdxList}));
if ~isempty(empty_idx)
    for i=1:length(empty_idx)
        cell.mask_cell(cell.mask_cell>empty_idx(i))=cell.mask_cell(cell.mask_cell>empty_idx(i))-1;
        empty_idx=empty_idx-1;
    end
    bw_props=regionprops(cell.mask_cell,'Centroid','PixelIdxlist');   % I could get MeanIntensity also for regionprops
end
%%
bw_props_=struct2cell(bw_props);
bw_props_names=fieldnames(bw_props);
cell.idx=bw_props_(contains(bw_props_names,'PixelIdxList'),:);
cell.cells_centre=vertcat(bw_props.Centroid);
