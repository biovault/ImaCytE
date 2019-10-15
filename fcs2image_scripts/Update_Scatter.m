function Update_Scatter(handles)

% Updates the colors of the cells in the scatter plot according to the assigned cluster
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global tsne_map
global cell4

if isempty(tsne_map); return; end

f_scatter=getappdata(handles.figure1,'Scatter_Figure');

point2cluster=horzcat(cell4(:).clusters);
cmap=getappdata(handles.figure1,'cmap');
colors=cmap(point2cluster,:);


delete(get(f_scatter,'Children'));
x=axes(f_scatter);
tsne_scatter=scatter(tsne_map(:,1),tsne_map(:,2),10,colors,'filled');
set(tsne_scatter,'ButtonDown',{@Image_Callback,0,point2cluster,handles});
% axes(x)
c = uicontextmenu;
Interact_per_point = uimenu('Parent',c,'Label','Point');
uimenu('Parent',Interact_per_point,'Label','Brush','Callback',{@Scatter_Context_Menu,handles});
set(x,'UIContextMenu',c);
set(x,'Position',[0.05 0.05 0.9 0.9]);
set(x,'Tag','Scatter_axes');
set(tsne_scatter,'Parent',x);


