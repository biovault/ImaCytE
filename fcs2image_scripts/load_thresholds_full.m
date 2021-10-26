function temp=load_thresholds_full(folder)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

fname=dir([folder '\*reshold.tiff']);    
fname=[fname.folder '\' fname.name];
info = imfinfo(fname);
numberOfImages = length(info);
temp=zeros(info(1).Height,info(1).Width,numberOfImages);
for l = 1:numberOfImages
    try
        temp(:,:,l) = imread(fname, l);%S, 'Info', info);
        temp(:,:,l)=temp(:,:,l)-1;
    catch
    end
end


