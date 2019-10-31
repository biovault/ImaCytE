function marker_selection_Callback(~,~,handles)

persistent chk

if isempty(chk)
    chk = 1;
    pause(0.5); %Add a delay to distinguish single click from a double click
    if chk == 1
        chk=[];
    end
else
    markers=getappdata(handles.figure1,'markers');
    [selection_markers,~] = listdlg('PromptString','Select markers to utilize:','ListString',markers);
    setappdata(handles.figure1,'selected_markers',selection_markers);
    color_assignment(handles)
    heatmap_data(handles)
    chk=[];
end



