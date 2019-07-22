function Markers_Callback(~, ~, handles)

% Callback function that presents the markers that the user can select for
% visualization
%   - handles: variable with all the handlers and saved variables of the

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

markers=getappdata(handles.figure1,'markers');
markers=horzcat('Clustered Data',markers);
% selection_markers=ListBox_selection(markers);
[selection_markers,~] = listdlg('PromptString','Select markers to utilize:','ListString',markers);

selection_samples=getappdata(handles.figure1,'selection_samples');


if length(selection_markers)>1
     if length(selection_samples)~=1
        errordlg('You should select 1 marker as more than 1 samples are selected','Selection Error');
        return
    elseif ~isempty(intersect(selection_markers,1))
        errordlg('You cannot select "Clustered Data" and another marker','Selection Error');
        return
    end
end
        
setappdata(handles.figure1,'selection_markers',selection_markers);
if selection_markers==1
    try 
        Update_Scatter(handles);
    catch 
    end
    Update_Tissue(handles);
else
    try
        Update_Scatter_Continious_var(handles);
    catch 
    end
    Update_Tissue_Continious_var(handles);
end 
