function [new,markers] = my_montage_img( fnam,tiles,flag )

% Load the cell segmentation mask(s) and concatenated according the tiles
% variable
%   - fnam: the filename of the cell segmentation masl
%   - tiles: a matrix with the position of each image

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

if nargin <3
    flag=0;  % for mask 
end

imgs=cell(length(fnam),1);
for i=1:length(fnam)
    fname = [fnam(i).folder '\' fnam(i).name];
    info = imfinfo(fname);
    markers=cell(1,length(info));
    for j = 1:length(info)
        currentImage = imread(fname,j, 'Info', info);
        imgs{i}(:,:,j)=currentImage;
        try
            markers{j}=strtok(info(j).PageName,'(');
        catch
        end
    end
end

dim_of_ROI=[min(cellfun('size',imgs,1)) min(cellfun('size',imgs,2))];

if flag
    new_max=0;
    for i=1:length(imgs)
        n_mask{i}=imgs{i}(1:dim_of_ROI(1),1:dim_of_ROI(2));

        %Cell uniqueness
        uni_in=unique(n_mask{i});
        new=[1:max(uni_in)]';
        ismember(new,uni_in);
        new(ans)=[1:(length(uni_in)-1)];
        new=[0; new];
        temp2=n_mask{i}+1;
        n_mask{i}=new(temp2);
  
        
        n_mask{i}(n_mask{i} ~= 0) =n_mask{i}(n_mask{i} ~= 0) + new_max;
        new_max=max(max(n_mask{i}));
    end
end
new=[];
for i=1:size(tiles,1)
    temp1=[];
    for j=1:size(tiles,2)
        temp1=[temp1 n_mask{tiles(i,j)+1}(1:dim_of_ROI(1),1:dim_of_ROI(2),:)];
    end
    new=[new ; temp1];
end

end

