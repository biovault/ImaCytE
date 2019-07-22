function Samples_Callback(~, ~, handles)

% Callback function that presents the samples that the user can select for
% visualization
%   - handles: variable with all the handlers and saved variables of the

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global cell4

samples={cell4(:).name};
% selection_samples=ListBox_selection(samples);   
[selection_samples,~] = listdlg('PromptString','Select samples to utilize:','ListString',samples);

selection_markers=getappdata(handles.figure1,'selection_markers');

if length(selection_samples)>1
    if length(selection_markers)~=1
        errordlg('You should select 1 sample as more than 1 markers are selected','Selection Error');
        return;
    end
end

setappdata(handles.figure1,'selection_samples',selection_samples);
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
