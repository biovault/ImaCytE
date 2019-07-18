function dendroCallBack(~,~,handles)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

prompt={'Threshold value for cluster partitioning' };
dlg_title='User defined cluster threshold';
cluster_name_ans=inputdlg(prompt,dlg_title);
color_assignment( handles, str2num(cluster_name_ans{1}))
Update_Scatter_Tissue(handles); 
heatmap_data(handles)
