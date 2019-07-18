function colormapCallBack(~,~,h)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

        prompt={'Min Value' ; 'Max Value'};
        dlg_title='User defined color threshold';
        cluster_name_ans=inputdlg(prompt,dlg_title);
        caxis(h,[str2num(cluster_name_ans{1}) str2num(cluster_name_ans{2})])


