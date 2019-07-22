function Show_Scatter_Selection_cont(list_of_cells,handles)

% Takes as argument the selected cells and highlights them in the scatter
% plot when a specific feature of the cells is visualized with the color channel
%   - list_of_cells: the id's of the selected cells
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global tsne_map
global n_data

f=findobj('Tag','Scatter_axes');

value1=getappdata(handles.figure1,'selection_markers');
value1=value1(1)-1;
valuemax=max(n_data(:,value1));
minvalue=min(n_data(:,value1));

cla(f);
colors=n_data(:,value1);
scatter(f,tsne_map(list_of_cells,1),tsne_map(list_of_cells,2),100,colors(list_of_cells),'+');

rest_cells=setdiff(1:length(colors),list_of_cells);
hold(f,'on') ; 
sc=scatter(f,tsne_map(rest_cells,1),tsne_map(rest_cells,2),5,colors(rest_cells)); 
colormap(viridis);
caxis([minvalue valuemax]);
c=colorbar(f);
set(c,'ButtonDown',{@colormapCallBack,f})

    w=scatter(f,tsne_map(:,1),tsne_map(:,2));
    set(w,'MarkerEdgeAlpha',0)
    set(w,'ButtonDown',{@Image_Callback_cont,0,handles});
c=colorbar(f);
set(c,'ButtonDown',{@colormapCallBack,f});

set(f,'Tag','Scatter_axes');
