function colormapCallBack_all(x,~,tissue)

% Callback upon selection of  the min and max values to of color to all the illustrated images 
%   - x: the object identifier of the images, of which the color axis variable is going to change 
%   -tissue: A cell structure, where each cell represents the object
%   identifier of each image

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox
persistent chk

if isempty(chk)
    chk = 1;
    pause(1); 
    if chk==1
        prompt={'Min Value' ; 'Max Value'};
        dlg_title='User defined color threshold';
        cluster_name_ans=inputdlg(prompt,dlg_title);

        for i=1:length(tissue)
            caxis(tissue(i),[str2num(cluster_name_ans{1}) str2num(cluster_name_ans{2})])
        end
        chk = [];
    end
else
    chk = [];
    prompt={'X' ; 'Y'; 'Width' ; 'Height'};
    dlg_title='Position of the colormap legend';
    dimensions=inputdlg(prompt,dlg_title);
    set(x,'Position',[str2num(dimensions{1}) str2num(dimensions{2}) str2num(dimensions{3}) str2num(dimensions{4})]);
end
end
