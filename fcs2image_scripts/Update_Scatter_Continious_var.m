function Update_Scatter_Continious_var(handles)

% Updates the colors of the cells in the scatter plot according to the
% assigned single feature
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global n_data
global tsne_map

if isempty(tsne_map); return; end

f_scatter=getappdata(handles.figure1,'Scatter_Figure');

markers=getappdata(handles.figure1,'markers');
selection_markers=getappdata(handles.figure1,'selection_markers');
if isempty(selection_markers); warndlg('Please select markers');   return; end
selection_markers=selection_markers -1;

colormap(viridis)
valuemax=max(n_data(:,selection_markers(1)));
minvalue=min(n_data(:,selection_markers(1)));

delete(get(f_scatter,'Children'));
x=axes(f_scatter);
tsne_scatter=scatter(x,tsne_map(:,1),tsne_map(:,2),10,n_data(:,selection_markers(1)),'filled');
set(tsne_scatter,'ButtonDown',{@Image_Callback_cont,0,handles});
        
caxis(x,[minvalue valuemax]); 
c=colorbar(x);
        set(c,'ButtonDown',{@colormapCallBack,x})
        title(x,[markers{selection_markers(1)}],'Interpreter','None');
        set(x,'Tag','Scatter_axes');
        axes(x);
        c = uicontextmenu;
        Interact_per_point = uimenu('Parent',c,'Label','Point');
%         uimenu('Parent',Interact_per_point,'Label','P.Select','Callback',{@Scatter_Context_Menu,handles,0});
        uimenu('Parent',Interact_per_point,'Label','Brush','Callback',{@Scatter_Context_Menu,handles});
        set(x,'UIContextMenu',c);
set(x,'Position',[0.05 0.05 0.85 0.9]);
set(x,'Tag','Scatter_axes');
set(tsne_scatter,'Parent',x);

end

