function dendroCallBack(~,~,handles)

% Callback upon selection of the threshold of for the partioning of the
% hierarchical clustering
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

prompt={'Threshold value for cluster partitioning' };
dlg_title='User defined cluster threshold';
cluster_name_ans=inputdlg(prompt,dlg_title);
color_assignment( handles, str2num(cluster_name_ans{1}))
Update_Tissue(handles); 
try 
    Update_Scatter(handles); 
catch
end
endheatmap_data(handles)
heatmap_data(handles)
