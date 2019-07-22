function imageStack=read_multitiff(fname)

% Reads a mutli tiff file and assigns it to a high-dimensional matrix
%   -fname: The filename of the multi tiff file

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