function  Cohort_comparison_Load(hObject, eventdata,handles)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

cluster_names=getappdata(handles.figure1, 'cluster_names');
cmap=getappdata(handles.figure1,'cmap');
Cohort_comparison(cmap,cluster_names);
end

