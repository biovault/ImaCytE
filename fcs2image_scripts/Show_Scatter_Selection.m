function Show_Scatter_Selection(list_of_cells,handles)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global tsne_map

f=findobj('Tag','Scatter_axes');

cmap=getappdata(handles.figure1,'cmap');
clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');

numClust=length(clustMembsCell);
for i=1:numClust
    point2cluster(clustMembsCell{i})=i;
end

rest_cells=setdiff(1:length(point2cluster),list_of_cells);
cla(f);
colors=cmap(point2cluster(list_of_cells),:);
scatter(f,tsne_map(list_of_cells,1),tsne_map(list_of_cells,2),100,colors,'+');
colors=cmap(point2cluster(rest_cells),:);

hold(f,'on') ;
if ~isempty(list_of_cells)
    s=scatter(f,tsne_map(rest_cells,1),tsne_map(rest_cells,2),1,colors,'filled');
    s.MarkerEdgeAlpha=1;
    s.MarkerFaceAlpha=0.3;
else
    scatter(f,tsne_map(rest_cells,1),tsne_map(rest_cells,2),10,colors,'filled');
end
% hold(f,'off') ;
%  
% hold(f,'on') ; 
w=scatter(f,tsne_map(:,1),tsne_map(:,2));
set(w,'MarkerEdgeAlpha',0);
set(w,'ButtonDown',{@Image_Callback,0,point2cluster,handles});
hold(f,'off') ;

set(f,'Tag','Scatter_axes');