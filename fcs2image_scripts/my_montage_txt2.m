function [new,markers] = my_montage_txt2(fnam,tiles)

% Load the high dimensional images and concatenated according the tiles
% variable
%   - fnam: the filename of the cell segmentation masl
%   - tiles: a matrix with the position of each image

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

imgs=cell(length(fnam),1);
for i=1:length(fnam)
    fname = [fnam(i).folder '\' fnam(i).name] ;
    info = imfinfo(fname);
    markers=cell(1,length(info));

    for j=1:length(info)
        currentImage = imread(fname,j, 'Info', info);
        
        
        
        markers{j}=strtok(info(j).PageName,'(');
        imgs{i}(:,:,j)=currentImage; 
    end
    
end

dim_of_ROI=[min(cellfun('size',imgs,1)) min(cellfun('size',imgs,2))];
new=[];
for i=1:size(tiles,1)
    temp1=[];
    for j=1:size(tiles,2)
        temp1=[temp1 imgs{tiles(i,j)+1}(1:dim_of_ROI(1),1:dim_of_ROI(2),:)];
    end
    new=[new ; temp1];
end

end

