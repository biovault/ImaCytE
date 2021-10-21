function temp=load_thresholds(folder,high_dim)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

        fnam=dir([folder '\*reshold.txt']);
        try
            table_thres=readtable([fnam.folder '\' fnam.name]);
            temp3=table_thres.ThresholdMin;
        catch
            temp3=importdata([fnam.folder '\' fnam.name]);
            temp3=temp3.textdata(2:end,4);
        end
        temp2=cellfun(@(x) str2num(strrep(x,',','.')),temp3);
        for i=1:size(high_dim,3)
            temp(:,:,i)=imbinarize(high_dim(:,:,i),temp2(i));
        end

end

