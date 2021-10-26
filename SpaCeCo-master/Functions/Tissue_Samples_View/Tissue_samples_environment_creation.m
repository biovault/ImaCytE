function Tissue_samples_environment_creation(~,~,handles)

global cell4

h = figure('units','normalized','outerposition',[0 0 1 1],'Name','Tissue Samples','NumberTitle','off','Color','White');
setappdata(handles.figure1,'tissue_samples',h);
colors=getappdata(handles.figure1,'cohort_colors');
cohort_names=getappdata(handles.figure1,'cohort_names');
selected=[];
num_cohorts=max([cell4(:).cohort]);
for i=1:num_cohorts
    hp = uipanel('Parent',h,'Title',cohort_names{i},'FontSize',18,'ForegroundColor',colors(i,:),...
             'BackgroundColor','white',...
             'Position',[0 (1-(i*1/num_cohorts)) 1 1/num_cohorts]);
    setappdata(handles.figure1,['cohort_panel' num2str(i)],hp)
%     uicontrol(hp,'Style', 'pushbutton', 'String', 'Samples','Units','normalized','position', [0.4 0.975 0.2 0.03 ], 'callback', {@ Samples_Callback, handles});
    temp_num=sum([cell4(:).cohort]==i);
%     selected=[selected; [(1:temp_num)' ones(temp_num,1).*i]];
end
setappdata(handles.figure1,'selection_samples',selected);
Update_Tissue_2(handles)




