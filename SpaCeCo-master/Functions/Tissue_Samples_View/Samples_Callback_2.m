function Samples_Callback(hObject, ~, handles)

% Callback function that presents the samples that the user can select for
% visualization
%   - handles: variable with all the handlers and saved variables of the

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global cell4
cohort_names=getappdata(handles.figure1,'cohort_names');
temp=get(hObject,'Parent');
selected_cohort=find(ismember(cohort_names,temp.Title));
samples={cell4([cell4(:).cohort]==selected_cohort).name};
% selection_samples=ListBox_selection(samples);   
[selection_samples,~] = listdlg('PromptString','Select samples to utilize:','ListString',samples);
selection_samples=[ selection_samples' ones(numel(selection_samples),1).*selected_cohort];

setappdata(handles.figure1,'selection_samples',selection_samples);
Update_Tissue_2(handles);
