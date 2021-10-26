function  Cell_Abundance_creation(~,~,handles)

global values_selection
global cell4
f = waitbar(0.4,'Please wait...');

cluster_names=getappdata(handles.figure1, 'cluster_names');
cmap=getappdata(handles.figure1, 'cmap');

per_image_clusters=getappdata(handles.figure1,'per_image_clusters');

if values_selection ==1
    per_image_clusters=per_image_clusters./sum(per_image_clusters,2);
end  

numClust=max(horzcat(cell4(:).clusters));
num_cohorts=max([cell4(:).cohort]);
for i=1:num_cohorts
    for j=1:numClust
        per_image_cluster_ids{i,j}=per_image_clusters(ismember([cell4(:).cohort],i),j);
    end
end
%% Create the visual encodings 

ax=getappdata(handles.figure1,'axes_cell_abundance');
for i=1:numClust
        my_density_graph(handles,ax(i),per_image_cluster_ids(:,i),cluster_names{i},cmap(i,:),i);
        set(ax(i),'ButtonDownFcn',{@dragObject_cluster,i});
        set(ax(i).YLabel,'ButtonDownFcn',{@Cluster_text_colors_change,handles});
end
close(f)