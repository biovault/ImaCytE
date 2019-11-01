function Show_Scatter_Selection(list_of_cells,handles)

% Takes as argument the selected cells and highlights them in the scatter
% plot when the cluster of the cells is visualized with the color channel
%   - list_of_cells: the id's of the selected cells
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global tsne_map
global cell4

f=findobj('Tag','Scatter_axes');
f=f(end);
cmap=getappdata(handles.figure1,'cmap');

point2cluster=horzcat(cell4(:).clusters);

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

w=scatter(f,tsne_map(:,1),tsne_map(:,2));
set(w,'MarkerEdgeAlpha',0);
set(w,'ButtonDown',{@Image_Callback,0,handles});
hold(f,'off') ;

set(f,'Tag','Scatter_axes');
