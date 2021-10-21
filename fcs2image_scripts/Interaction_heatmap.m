function Interaction_heatmap(f,adj,sizes,handles,clusteri)

% Illustration of the frequencies a cluster colocalizes with another
% cluster
%   - f: identifier of the figure object whehre the interaction heatmap
%   will be build upon
%   - adj: Matrix representing the cluster to cluster frequency
%   - handles: variable with all the handlers and saved variables of the
%   environment
%   - sizes: The number of cells that each cluster has
%   - handles: variable with all the handlers and saved variables of the
%   environment
%   - clusteri: matrix wehre each row represent the cell ids of the cells that exist
%   in their neihgborhood

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

try 
    temp=get(f,'Children');
    delete(temp);
catch
end
popup=uicontrol( f,'Style', 'popup',...
           'String', {'Normalize per column','Normalize per row','Normalize per column excluding','Absolute counts','Permutation test'},...
           'Position', [0.01 0 0.12 0.07],'Units','normalized',...
           'Callback', {@Interaction_heatmap_Callback,handles}); 
set(popup,'Position',[0.87 0.9 0.12 0.07]);
clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
numclust=length(clustMembsCell);
cmap=getappdata(handles.figure1,'cmap');
cluster_names=getappdata(handles.figure1, 'cluster_names');

if size(sizes,1)==1
    sizes=sizes';
end

%% Find the cells that correspond to an interaction illustrated in the heatmap
temp2=getappdata(handles.figure1,'mat_inter');
if isempty(temp2)
    for i=1:length(clustMembsCell)
        for j=1:length(clustMembsCell)
            temp=clusteri(clustMembsCell{i},:);
            temp=unique(temp(:));
            temp=temp(2:end);
            temp2=intersect(clustMembsCell{j},temp);
            temp3=clusteri(temp2,:);
            temp3=unique(temp3(:));
            temp3=temp3(2:end);
            temp4=intersect(clustMembsCell{i},temp3);
            mat_interactions{i,j}=[temp4 ; temp2];
        end
    end
%     setappdata(handles.figure1,'mat_inter',mat_interactions);
else
    mat_interactions=temp2;
end

%% Illustration of the heatmap showing the colocalization frequency
ax_=axes(f);
axes(ax_)
rt=my_heatmap(adj,cluster_names,cluster_names,[], 'TickAngle', 60,'ShowAllTicks', true);
get(rt,'Parent');
set(ans,'YAxisLocation','right');
er=xlabel(ax_,'Cells of Interest');
set(er,'Units','normalized');
set(er,'Position',[ 0.5 -0.11 0]);

ylabel(ax_,'Cells in their Neighborhood')
c = gray;
c = flipud(c);
colormap(c);
caxis([0 1]);
c=colorbar;
set(c,'ButtonDown',{@colormapCallBack,ax_})
set(rt,'ButtonDownFcn',{@Heatmap_Callback,handles,mat_interactions});
set(rt,'Tag','H_i');

%% Illustraiton at the top of the heatmap of the sizes of each cluster
ax3=axes(f);
rw3=my_bar(sizes,[],cmap,ax3);
set(ax3, 'visible', 'off')
set(ax3,'xlim',[0.5 numclust+0.5])
set(rw3,'BarWidth',1)
title(ax3,'Cluster types');

%% below the sizes and above the heatmap, illustration of the color of each cluster
ax4=axes(f);
rw4=my_bar(ones(size(sizes,1),1),[],cmap,ax4);
set(ax4, 'visible', 'off')
set(ax4,'xlim',[0.5 numclust+0.5])
set(rw4,'BarWidth',1)
set(rw4,'ButtonDownFcn',{@nodeCallback,handles});

%% On the left of the heatmap, illustration of the color of each cluster

ax5=axes(f);
rw5=my_barh(ones(size(sizes,1),1),[],cmap,ax5);
set(ax5, 'visible', 'off')
set(ax5,'ylim',[0.5 numclust+0.5])
set(rw5,'BarWidth',1)
set(ax5,'Ydir','reverse')
set(ax5,'Xdir','reverse')

%% Arranging the position of the illustrations
set(ax_,'Position',[0.05 0.12 0.7 0.79]);
set(ax3,'Position',[0.05 0.95 0.7 0.04]);
set(ax4,'Position',[0.05 0.915 0.7 0.03])
set(ax5,'Position', [0.02 0.12 0.02 0.79])

setappdata(handles.figure1,'h_i',rt);
setappdata(handles.figure1,'h_i_ver',rw5);
setappdata(handles.figure1,'h_i_hor',rw4);
setappdata(handles.figure1,'cell_sizes',rw3);

setappdata(handles.figure1,'mat_interactions',mat_interactions);
set(handles.figure1,'windowbuttonmotionfcn',{@mousemove_interaction,handles});


function Heatmap_Callback(hObject,~,handles,mat_interactions)

% Callback upon selection of a box in the heatmap, it highlights the cells
% with such an interaction nd filters the motifs

persistent chk
persistent points

w=get(hObject,'CData');
a2=get(hObject,'Parent');
a=get(a2,'currentpoint');
a=round(a(1,1:2));
points=setxor(points,sub2ind(size(w),a(:,2),a(:,1)));
delete(findobj(handles.figure1,'tag','Rect_perm')); %delete last tool tip

if isempty(chk)
    chk = 1;
    pause(0.2); %Add a delay to distinguish single click from a double click
    if chk == 1
       chk=[];
       try
        Show_Tissue_Selection(vertcat(mat_interactions{points}),handles);
       catch
           points=[];
       end
    end
else
    chk = [];
    points=[];
    Show_Tissue_Selection([],handles);
end
    delete(findobj(handles.figure1,'tag','Rect2')); %delete last tool tip

% a=get(handles.axes8,'children');
new_a=[];
for i=1:length(points)
    [new_a(i,2),new_a(i,1)]=ind2sub(size(w),points(i));
    rect=rectangle(a2,'Position',[new_a(i,1)-0.5 new_a(i,2)-0.5 1 1],'EdgeColor','r');
    set(rect,'Tag','Rect2');
    set(rect,'PickableParts','none')

end

z=getappdata(handles.figure1,'z');
fr=getappdata(handles.figure1,'fr');
motifs=getappdata(handles.figure1,'motifs');
idx_motif_cells=getappdata(handles.figure1,'idx_motif_cells');
motif_idx=getappdata(handles.figure1,'motif_idx');
hfig=getappdata(handles.figure1,'hfig');
event.Value=7;
I=1:size(motifs,1);
Motif_Selection_Callback(event,new_a,hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I);

function nodeCallback(hObject,~,handles)

% Callback upon selection of one of the boxes above the heatmap that highlights all the cells
% of that cluster with their interacting cells

persistent chk
persistent points2
clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');

a=hObject.XData;
points2=setxor(points2,a);
    delete(findobj(handles.figure1,'tag','Rect2')); %delete last tool tip

if isempty(chk)
    chk = 1;
    pause(0.2); %Add a delay to distinguish single click from a double click
    if chk == 1
       chk=[];
    end
else
    chk = [];
    points2=[];
end

h_i=getappdata(handles.figure1,'h_i');
a=get(h_i,'parent');
delete(findobj(handles.figure1,'tag','Rect_perm')); %delete last tool tip

for i=1:length(points2)
    rect=rectangle(a,'Position',[points2(i)-0.5 0 1 size(h_i.CData,1)+0.5],'EdgeColor','r');
    set(rect,'Tag','Rect_perm');
    set(rect,'PickableParts','none')
end

setappdata(handles.figure1,'points_hi',points2);
z=getappdata(handles.figure1,'z');
fr=getappdata(handles.figure1,'fr');
motifs=getappdata(handles.figure1,'motifs');
idx_motif_cells=getappdata(handles.figure1,'idx_motif_cells');
motif_idx=getappdata(handles.figure1,'motif_idx');
hfig=getappdata(handles.figure1,'hfig');
event.Value=6;
I=1:size(motifs,1);
Motif_Selection_Callback(event,unique(points2),hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I);
Show_Tissue_Selection(horzcat(clustMembsCell{points2}),handles);

