function Heatmap_Context_menu(source,~,handles)

% Callback upon selection of the heatmap for either the merging of clusters.
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

    global heatmap_selection
    switch source.Label
        case 'Merge Selected Clusters'
    %         heatmap_selection=leaforder(heatmap_selection);
            p5=unique(heatmap_selection);

            prompt={'Give a name for this cluster'};
            dlg_title='Cluster Annotation';
            num_lines=1;
            cluster_name_ans=inputdlg(prompt,dlg_title,num_lines);
            cluster_names=getappdata(handles.figure1, 'cluster_names');
            try 
                cluster_names{p5(1)}=cluster_name_ans{1}; 
                cluster_names(p5(2:end))=[];
                setappdata(handles.figure1, 'cluster_names',cluster_names);
            catch
                return
            end

            clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
            new_points=clustMembsCell(p5);
            new_points=horzcat(new_points{:});
            clustMembsCell{p5(1)}=new_points;
            clustMembsCell(p5(2:end))=[];
            clustMembsCell=clustMembsCell(~cellfun('isempty',clustMembsCell));
            setappdata(handles.figure1, 'clustMembsCell', clustMembsCell)

            cmap=getappdata(handles.figure1, 'cmap');
            cmap(p5(2:end),:)=[];
            setappdata(handles.figure1, 'cmap', cmap)

            Update_Scatter(handles);
            Update_Tissue(handles);
            heatmap_data(handles)
            heatmap_selection=[];
    end

