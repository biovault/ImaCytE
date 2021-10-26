function dropObject(hObject,eventdata,handles)
global dragging
global dropped
global cell4
global values_selection


f=getappdata(handles.figure1,'cell_type_fig');
cluster_names=getappdata(handles.figure1, 'cluster_names');

        if ~isempty(dragging)  && isvalid(dragging)
            cc = get(gcf,'CurrentPoint');
            if ( cc(2)>=0.8)  && ( cc(2)<=1) && cc(1)<1 &&cc(1)>0
                per_image_clusters=getappdata(handles.figure1,'per_image_clusters');
                if values_selection==1
                    per_image_clusters=per_image_clusters./sum(per_image_clusters,2);
                end
                per_image_clusters=sum(per_image_clusters(:,dropped),2);
                num_cohorts=max([cell4(:).cohort]);
                for i=1:num_cohorts
                    per_image_cluster_ids{i}=per_image_clusters(ismember([cell4(:).cohort],i),:);
                end
                ax=getappdata(handles.figure1,'temporary_axes');
                delete(ax);
                ax=axes(f);
                set(ax,'Position',[0.05 0.83 0.9 0.09]);
                my_density_graph(handles,ax,per_image_cluster_ids,strjoin(cluster_names(dropped),' '),[0 0 0],dropped); %\n
                set(ax,'ButtonDownFcn',{@droped_axes_ButtonDown})
                d = uicontextmenu;
                uimenu('Parent',d,'Label','Filter','Callback',{@Brush_context_menu,handles,0});
                uimenu('Parent',d,'Label','Reset','Callback',{@Brush_context_menu,handles,0});
                set(ax,'UIContextMenu',d); 
%                 set(ax.YLabel,'ButtonDownFcn',{@Cluster_text_colors_change,handles});
                setappdata(handles.figure1,'temporary_axes',ax);
            end
            delete(dragging);
        end
end


