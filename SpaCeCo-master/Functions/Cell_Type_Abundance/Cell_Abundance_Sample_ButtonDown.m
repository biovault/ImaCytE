function Cell_Abundance_Sample_ButtonDown(hObject,evnt,handles,num)
    
    persistent chk  
    global tsne_idx
    global cell4
    persistent temp_num
    if isempty(num) ; num=temp_num; end
    if isempty(temp_num); chk=1; end
    temp_num=num;
    

    selected=getappdata(handles.figure1,'selection_samples');
    h=getappdata(handles.figure1,'cell_type_fig');
    colors=getappdata(handles.figure1,'cohort_colors');
    clustMembsCell=getappdata(handles.figure1,'clustMembsCell');
    transparency_param=0.1;
    temp2=get(gcf);
    if isequal(temp2.Name, 'Co-localization patterns')
        h=getappdata(handles.figure1,'colocalization_details');
        idxs=getappdata(handles.figure1,'coloc_idxs');
%         if isempty(hObject.Parent.YLabel.String)
%             temp_cluster=1;
%         else
%             temp=get(hObject.Parent,'Children');
%         end
%         temp_cluster=ismember([''  'None' cluster_names ],hObject.Parent.YLabel.String);
    end   
    if isempty(chk) 
        chk = 1;
        pause(0.5); %Add a delay to distinguish single click from a double click
        if chk == 1
            if isempty(hObject)
                temp=[]; 
            else
                [temp,temp_]=strtok(hObject.Tag,' ');
                temp=[str2num(temp) str2num(temp_)]; 
%                 [~,temp]=min(abs(hObject.XData - evnt.IntersectionPoint(1)));
%                 temp=[temp find(ismember(colors,hObject.MarkerFaceColor,'row'))];
            end

            selected=[selected ; temp];
            selected=unique(selected,'rows');
            w=findobj(h,'Tag','White_parts');
            for i=1:numel(w)
                w(i).FaceAlpha=0;
            end
            for j=1:size(colors,1)
                w=findobj(h,'FaceColor',colors(j,:),'-or','Type','patch');
                for i=1:numel(w)
                    w(i).FaceAlpha=transparency_param;
                end
            end
            for i=1:size(selected,1)
                temp_color=colors(selected(i,2),:);
                w=findobj(h,'Tag',[num2str(selected(i,1)) ' ' num2str(selected(i,2))]);
                for j=1:numel(w)
                    w(j).FaceAlpha=1;
                end
            end
            chk=[];
            setappdata(handles.figure1,'selection_samples',selected);
            if exist('idxs','var')==1
                cluster_of_micro=getappdata(handles.figure1,'cluster_of_micro');
                clusteri=getappdata(handles.figure1,'clusteri');
                temp_=cohort_idx_2_idx(selected);
                temp1=idxs(temp_,num);
                clusteri=vertcat(clusteri{:});
                clusteri=clusteri([temp1{:}],:);
                clusteri=unique(clusteri(:));
                clusteri=clusteri( clusteri ~=0);
                temp3=[cell4(:).clusters];
                clusteri=clusteri(ismember(temp3(clusteri),cluster_of_micro));
                Show_Tissue_Selection_2(unique([clusteri' [temp1{:}]]),handles);
            else
                temp1=cohort_idx_2_idx(selected);
                temp_clusters=[clustMembsCell{num}];
                Show_Tissue_Selection_2(temp_clusters(ismember(tsne_idx(temp_clusters'),temp1)),handles);
            end
        end
    else
        for j=1:size(colors,1)
            w=findobj(h,'FaceColor',colors(j,:),'-or','Type','patch');
            for i=1:numel(w)
                w(i).FaceAlpha=1;
            end
        end
        w=findobj(h,'Tag','White_parts');
        for i=1:numel(w)
            w(i).FaceAlpha=1;
        end
        chk=[];
        selected=[];
        setappdata(handles.figure1,'selection_samples',selected);
        Show_Tissue_Selection_2([],handles);
    end
end