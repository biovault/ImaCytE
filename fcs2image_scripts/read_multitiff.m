function imageStack=read_multitiff(fname)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

info = imfinfo(fname);
numberOfImages = length(info);
imageStack=zeros(info(1).Height,info(1).Width,numberOfImages);
for l = 1:numberOfImages
    try
        imageStack(:,:,l) = imread(fname, l);%S, 'Info', info);
    catch
    end
end
end