function cluster_per_sample(handles)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global tsne_idx
global cell4

cluster_names=getappdata(handles.figure1, 'cluster_names');
clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
numClust=length(clustMembsCell);
per_image_clusters=zeros(length(cell4),numClust);

for i=1:numClust
    t=tsne_idx(clustMembsCell{i});
    temp=accumarray(t',1);
    per_image_clusters(1:length(temp),i)=temp;
end
clustergram(per_image_clusters./(sum(per_image_clusters,2)),'Colormap',viridis,'RowLabels',{cell4(:).name},'ColumnLabels',cluster_names);
