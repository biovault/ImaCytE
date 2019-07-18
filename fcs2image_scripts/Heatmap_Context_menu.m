function Heatmap_Context_menu(source,~,handles)

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
        case 'Annotate Selected Cluster'
            prompt={'Give a name for this cluster'};
            dlg_title='Cluster Annotation';
            num_lines=1;
            cluster_name_ans=inputdlg(prompt,dlg_title,num_lines);
            cluster_names=getappdata(handles.figure1, 'cluster_names');
            try cluster_names{heatmap_selection(1)}=cluster_name_ans{1}; catch ; end
            setappdata(handles.figure1, 'cluster_names',cluster_names);
            heatmap_data(handles)
        case 'Change Color'

            T=getappdata(handles.figure1,'h_cluster');
            colors=[23 118 182 ;...
            255 127 0 ; ...
            36 161 33; ...
            216 36 31 ; ...
            141 86 73 ; ...
            229 116 195];
        % ...
        %     149 100 91; ...
        %     0 190 208;...
        %     188 191 0];
            hsv_colors=rgb2hsv(colors/255);

            colors_=Color_Selection;

            T=colors_;
            cmap=zeros(length(T),3);
            for i=1:max(T)
                idxs=find(T==i);
                if length(idxs)==1
                        temp=hsv_colors(i,:);
                else
            %     [~,c]=kmeans(nchoosek([0.4:0.01:1],2),length(idxs));
            %     temp=[repmat(hsv_colors(i,1),length(idxs),1) c(:,1)  c(:,2)];
                    [~,c]=kmeans([0.1:0.01:1]',length(idxs));
                    temp=[repmat(hsv_colors(i,1),length(idxs),1) c  repmat(hsv_colors(i,3),length(idxs),1)];
                end
                cmap(idxs,:)=temp;
            end
            cmap=hsv2rgb(cmap);

    end

