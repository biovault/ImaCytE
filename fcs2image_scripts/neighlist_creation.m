function [matr,adj]=neighlist_creation(mask_cell,number_of_pixels,bb)

% Function that detects the cells that exist in the microenvironment of a
% cell
%   - mask_cell: the cell mask , where each pixel has the cell_id of the
%   cells that belongs to. Background has 0 valu
%   - number_of_pixels: number of pixels that want to dilate and search for
%   neighbors away from cell
%   - bb: Bounding box that includes each cell, in order to narrow down the
%   image size during the detection


%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

    if nargin<2
        number_of_pixels=3;
    end
    if nargin<3
        bb=regionprops(mask_cell,'BoundingBox');
    end
    radius=2*number_of_pixels+1;

%% Dilate/parse only a part of the image 
    tmp=max(mask_cell(:));
    adj=zeros(tmp);
    matr=cell(1,length(bb));
    for i=1:length(bb)
        min_x=round(bb(i).BoundingBox(1)) - number_of_pixels;
        if min_x<1; min_x=1; end
        max_x=round(bb(i).BoundingBox(1))+bb(i).BoundingBox(3) + number_of_pixels;
        if max_x> size(mask_cell,2); max_x=size(mask_cell,2); end
        min_y=round(bb(i).BoundingBox(2)) - number_of_pixels;
        if min_y<1; min_y=1; end
        max_y=round(bb(i).BoundingBox(2))+bb(i).BoundingBox(4) + number_of_pixels;
        if max_y> size(mask_cell,1); max_y=size(mask_cell,1); end
        new_mask=mask_cell(min_y:max_y,min_x:max_x);
        temp=imdilate(new_mask==i,ones(radius));
        matr{i}=unique(new_mask(temp));
%         matr{i}=unique(new_mask);
        matr{i}=matr{i}(matr{i} ~=i ); %& For not including 0 : & matr{i} ~=0
        matr{i}=matr{i}( matr{i} ~=0);
        adj(i,matr{i})=1;
    end
    
    
end
