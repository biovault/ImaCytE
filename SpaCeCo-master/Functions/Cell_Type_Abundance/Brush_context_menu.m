function Brush_context_menu(hObject,evnt,handles,idx)

global cell4
global tsne_idx

% persistent origin_data
% persistent threshold

% count=getappdata(handles.figure1,'original_data');
% count=count+1;
% if count==1
%     origin_data=cell4;
% end
% setappdata(handles.figure1,'count_interaction',count);


% Handle response
switch hObject.Text
    case 'Filter'
%         zoom on
        h = zoom;
        set(h, 'ActionPostCallback', {@zoo_limit,handles,idx,h});
        h.Enable='on';
        
    case 'Reset'
        cell4=getappdata(handles.figure1,'original_data');
        tsne_idx=[];
        for i=1:length(cell4)
            tsne_idx=[ tsne_idx ones(1,length(cell4(i).idx))*i];
        end
        handles = cell2clust(handles);
        Cell_Abundance_environment_creation([],[],handles)
end

function zoo_limit(obj,evnt,handles,idx,h)
global cell4
global tsne_idx
global values_selection
global dropped

threshold=evnt.Axes.XLim;
per_image_clusters=getappdata(handles.figure1,'per_image_clusters');
        if values_selection ==1
            per_image_clusters=per_image_clusters./sum(per_image_clusters,2);
        end 
        if isequal(idx,0) % Check if it is the drop area axis or not
            selection_samples=find(sum(per_image_clusters(:,dropped),2)>=threshold(1) & sum(per_image_clusters(:,dropped),2)<=threshold(2) );
        else
            selection_samples=find( per_image_clusters(:,idx)>=threshold(1) & per_image_clusters(:,idx)<=threshold(2) );
        end
        cell4=cell4(selection_samples);
        tsne_idx=[];
        for i=1:length(cell4)
            tsne_idx=[ tsne_idx ones(1,length(cell4(i).idx))*i];
        end
        handles = cell2clust(handles);
        Cell_Abundance_environment_creation([],[],handles)


