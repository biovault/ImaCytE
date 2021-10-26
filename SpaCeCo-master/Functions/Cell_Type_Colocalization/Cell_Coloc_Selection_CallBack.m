function Cell_Coloc_Selection_CallBack(source,~,handles)

    persistent seperability_value
    if isempty(seperability_value) ; seperability_value=1; end     
    persistent ordering
    if isempty(ordering) ; ordering='descend'; end
    
    global values_selection
    global dropped2
    global dropped3
    global cell4
    
    hfig=getappdata(handles.figure1,'colocalization_details');
    per_image_clusters=getappdata(handles.figure1,'per_image_clusters');
    ax=getappdata(handles.figure1,'axes_coloc');
    temp_pos=getappdata(handles.figure1,'initial_pos_coloc');
    temp_tab=getappdata(handles.figure1,'initial_tab_coloc');

    if isequal(source.Style,'radiobutton')
        switch source.String
            case 'Absolute'
                values_selection=0;
                Colocalization_details_environment_creation(handles,dropped2,dropped3)
            case 'Relative'
                values_selection=1;
                Colocalization_details_environment_creation(handles,dropped2,dropped3)
            case 'Ascending'
                ordering='ascend';
                reordering(values_selection,seperability_value,ordering,temp_pos,temp_tab,per_image_clusters,cell4,ax,handles);
            case 'Descending'
                ordering='descend';
                reordering(values_selection,seperability_value,ordering,temp_pos,temp_tab,per_image_clusters,cell4,ax,handles);
        end      
    elseif isequal(source.Style,'checkbox')
        if isequal(source.Value,0)
            temp2='off';
            temp=findobj(hfig,'Tag','Metrics');
            temp.Enable=temp2;
            temp=findobj(hfig,'String','Descending');
            temp.Enable=temp2;
            temp=findobj(hfig,'String','Ascending');
            temp.Enable=temp2;
            for i=1:length(ax)
                set(ax(i),'Parent',temp_tab{i});
                set(ax(i),'Position',temp_pos(i,:));
            end
        else
            temp2='on';
            temp=findobj(hfig,'Tag','Metrics');
            temp.Enable=temp2;
            temp=findobj(hfig,'String','Descending');
            temp.Enable=temp2;
            temp=findobj(hfig,'String','Ascending');
            temp.Enable=temp2;
            reordering(values_selection,seperability_value,ordering,temp_pos,temp_tab,per_image_clusters,cell4,ax,handles);
        end
    elseif isequal(source.Style,'popupmenu')
        seperability_value=source.Value;
        reordering(values_selection,seperability_value,ordering,temp_pos,temp_tab,per_image_clusters,cell4,ax,handles);
    elseif isequal(source.Style,'edit')
        for i=1:length(ax)
            cluster_names{i}=ax(i).YLabel.String;
        end
        I=find(contains(cluster_names,source.String{1},'IgnoreCase',true));
        I=[I setdiff(1:length(ax),I)];
        for i=1:length(I)
            set(ax(I(i)),'Parent',temp_tab{i});
            set(ax(I(i)),'Position',temp_pos(i,:));
        end        
    end
    
selected=getappdata(handles.figure1,'selection_samples');    
if ~isempty(selected); Cell_Abundance_Sample_ButtonDown([],[],handles,[]); end


function reordering(values_selection,seperability_value,ordering,temp_pos,temp_tab,per_image_clusters,cell4,ax,handles)
    per_sample_values=getappdata(handles.figure1,'per_sample_coloc');
    if values_selection ==1
       per_sample_values=per_sample_values./sum(per_image_clusters,2);
    end  
    for i=2:size(per_sample_values,2)
        seperability_metric(i-1)=valid_clusterIndex(per_sample_values(:,i),[cell4(:).cohort],seperability_value);
    end
    [~,I]=sort(seperability_metric,ordering);
    for i=1:length(I)
        set(ax(I(i)),'Parent',temp_tab{i});
        set(ax(I(i)),'Position',temp_pos(i,:));
    end  
