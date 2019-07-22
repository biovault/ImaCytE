function Update_Scatter(handles)

% Updates the colors of the cells in the scatter plot according to the assigned cluster
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global tsne_map
if isempty(tsne_map); return; end

f_scatter=getappdata(handles.figure1,'Scatter_Figure');

clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
numClust=length(clustMembsCell);

for i=1:numClust
    point2cluster(clustMembsCell{i})=i;
end

cmap=getappdata(handles.figure1,'cmap');
colors=cmap(point2cluster,:);


delete(get(f_scatter,'Children'));
x=axes(f_scatter);
tsne_scatter=scatter(tsne_map(:,1),tsne_map(:,2),10,colors,'filled');
%         tsne_scatter=gscatter(tsne_map(:,1),tsne_map(:,2),point2cluster);
%         setappdata(handles.figure1,'tsne_scatter',tsne_scatter);
set(tsne_scatter,'ButtonDown',{@Image_Callback,0,point2cluster,handles});
axes(x)
c = uicontextmenu;
Interact_per_point = uimenu('Parent',c,'Label','Point');
uimenu('Parent',Interact_per_point,'Label','Brush','Callback',{@Scatter_Context_Menu,handles});
% uimenu('Parent',Interact_per_point,'Label','Sample_vars','Callback',{@scatter_overlay,handles});
set(x,'UIContextMenu',c);
set(x,'Position',[0.05 0.05 0.9 0.9]);
set(x,'Tag','Scatter_axes');
set(tsne_scatter,'Parent',x);

end

