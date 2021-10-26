function [temp,markers]=load_thresholds_all_markers(folder)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

fname=dir([folder '\*reshold.tiff']);    
% fname=[fname.folder '\' fname.name];
% info = imfinfo(fname);
numberOfImages = length(fname);
% temp=zeros(info(1).Height,info(1).Width,numberOfImages);
for l = 1:numberOfImages
    try
        temp(:,:,l) = imread([fname(l).folder '\' fname(l).name]);%S, 'Info', info);
        temp(:,:,l)=temp(:,:,l)-1;
        markers{l}=fname(l).name(1:end-14);
    catch
    end
end
