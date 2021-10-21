function scatter_overlay(handles)

global tsne_map
global tsne_idx
global cell4

if isempty(tsne_map); return; end

clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
numClust=length(clustMembsCell);
for i=1:numClust
    point2cluster(clustMembsCell{i})=i;
end

temp=fieldnames(cell4);
temp=setdiff(temp,{'mask_cell';'high_dim_img';'cell_markers';'cell_borders';'idx';'cells_centre';'data';'neighlist'});
[marker,~] = listdlg('PromptString','Select categorical variables to overlay in scatter:','ListString',temp,'SelectionMode','single');
temp={cell4(:).(temp{marker})};

custom_string='Unknown';
temp2=cellfun(@isnan,temp , 'UniformOutput', false);
temp2=cellfun(@(C) any(C==1), temp2,'UniformOutput', false);
temp2=cell2mat(temp2);
temp(temp2)={custom_string};

try temp=categorical(temp);
catch 
    temp=cell2mat(temp);
    temp=categorical(temp);
end

numver_of_categories=length(unique(temp));
temp=temp(tsne_idx);

f_scatter=getappdata(handles.figure1,'Scatter_Figure');

delete(get(f_scatter,'Children'));
x=axes(f_scatter);
tsne_scatter=gscatter(tsne_map(:,1),tsne_map(:,2),temp);
leg=legend;
leg.ItemHitFcn = @show_legend_selection;
leg.UserData=handles;
% set(leg,'Parent',x);


axes(x)
c = uicontextmenu;
Interact_per_point = uimenu('Parent',c,'Label','Point');
uimenu('Parent',Interact_per_point,'Label','Brush','Callback',{@Scatter_Context_Menu,handles});
% uimenu('Parent',Interact_per_point,'Label','Sample_vars','Callback',{@scatter_overlay,handles});
set(x,'UIContextMenu',c);
set(x,'Position',[0.05 0.05 0.9 0.9]);

hold(x,'on') ;
w=scatter(x,tsne_map(:,1),tsne_map(:,2));
set(w,'MarkerEdgeAlpha',0);
set(w,'ButtonDown',{@Image_Callback,0,point2cluster,handles});
hold(x,'off') ;
leg.String=leg.String(1:numver_of_categories);

set(x,'Tag','Scatter_axes');
set(tsne_scatter,'Parent',x);

