function Interaction_heatmap_2(f,adj,sizes,handles,clusteri)

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

clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
numclust=length(clustMembsCell);
cmap=getappdata(handles.figure1,'cmap');
cluster_names=getappdata(handles.figure1, 'cluster_names');

if size(sizes,1)==1
    sizes=sizes';
end

%% Find the cells that correspond to an interaction illustrated in the heatmap

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

%% Illustration of the heatmap showing the colocalization frequency
ax_=axes(f);
axes(ax_)
rt=my_heatmap(adj,cluster_names,[],[], 'TickAngle', 60,'ShowAllTicks', true);
% pbaspect([1 1 1])

get(rt,'Parent');
set(ans,'YAxisLocation','right');
er=xlabel(ax_,'Cells of Interest');
set(er,'Units','normalized');
set(er,'Position',[ 0.5 1.17 0]);

ylabel(ax_,'Cells in their Neighborhood')
colormap(redblueTecplot);
caxis([-1 1]);
% caxis([-max(adj(:)) max(adj(:))]);
c=colorbar;
c.Location='southoutside';
set(c,'ButtonDown',{@colormapCallBack,ax_})
set(rt,'ButtonDownFcn',{@Heatmap_Callback,handles,mat_interactions});
set(rt,'Tag','H_i');

%% below the sizes and above the heatmap, illustration of the color of each cluster
ax4=axes(f);
rw4=my_bar(ones(size(sizes,1),1),[],cmap,ax4);
% pbaspect([size(sizes,1) 1 1])

set(ax4, 'visible', 'off')
set(ax4,'xlim',[0.5 numclust+0.5])
set(rw4,'BarWidth',1)
set(rw4,'ButtonDownFcn',{@nodeCallback,handles});

%% On the left of the heatmap, illustration of the color of each cluster

ax5=axes(f);
rw5=my_barh(ones(size(sizes,1),1),[],cmap,ax5);
% pbaspect([1 size(sizes,1) 1])

set(ax5, 'visible', 'off')
set(ax5,'ylim',[0.5 numclust+0.5])
set(rw5,'BarWidth',1)
set(ax5,'Ydir','reverse')
set(ax5,'Xdir','reverse')

%% Arranging the position of the illustrations
temp_heat=0.85;  %0.6
diff_param=0.4; %0.8
x_axis_param=0; %0.15;
set(ax_,'Position',[x_axis_param+temp_heat/size(sizes,1) 0.4 temp_heat temp_heat*diff_param]);
temp_dim=get(ax_,'Position');
set(ax4,'Position',[temp_dim(1) temp_dim(2)+temp_dim(4) temp_dim(3) temp_heat/size(sizes,1)*diff_param])
set(ax5,'Position', [x_axis_param temp_dim(2) temp_heat/size(sizes,1) temp_dim(4)])

setappdata(handles.figure1,'h_i',rt);
setappdata(handles.figure1,'h_i_ver',rw5);
setappdata(handles.figure1,'h_i_hor',rw4);
% setappdata(handles.figure1,'cell_sizes',rw3);

setappdata(handles.figure1,'mat_interactions',mat_interactions);
set(handles.figure1,'windowbuttonmotionfcn',{@mousemove_interaction,handles});


function Heatmap_Callback(hObject,evnt,handles,mat_interactions)

% Callback upon selection of a box in the heatmap, it highlights the cells
% with such an interaction nd filters the motifs

persistent chk
persistent points
global dropped2
global dropped3
w=get(hObject,'CData');
a2=get(hObject,'Parent');
a=evnt.IntersectionPoint;
a=round(a(1,1:2));
points=setxor(points,sub2ind(size(w),a(:,2),a(:,1)));
delete(findobj(handles.figure1,'tag','Rect_perm')); %delete last tool tip


if isempty(chk)
    chk = 1;
    pause(0.2); %Add a delay to distinguish single click from a double click
    if chk == 1
       chk=[];
       dropped2=[dropped2 round(a(1,1))];
       dropped2=unique(dropped2,'stable');
       dropped3=[dropped3 round(a(1,2))];
       dropped3=unique(dropped3,'stable');
       Show_Tissue_Selection_2(vertcat(mat_interactions{points}),handles);
    end
else
    chk = [];
    points=[];
    dropped2=[];
    dropped3=[];
    delete(findobj('tag','Rect_perm')); %delete last tool tip
    setappdata(handles.figure1,'selection_samples',[]);
    Show_Tissue_Selection_2([],handles);
end
delete(findobj('tag','Rect2')); %delete last tool tip

% a=get(handles.axes8,'children');
new_a=[];
for i=1:length(points)
    [new_a(i,2),new_a(i,1)]=ind2sub(size(w),points(i));
    rect=rectangle(a2,'Position',[new_a(i,1)-0.5 new_a(i,2)-0.5 1 1],'EdgeColor','r');
    set(rect,'Tag','Rect2');
    set(rect,'PickableParts','none')
end
Colocalization_details_environment_creation(handles,dropped2,dropped3)



function nodeCallback(hObject,~,handles)

% Callback upon selection of one of the boxes above the heatmap that highlights all the cells
% of that cluster with their interacting cells
global dropped2
global dropped3
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
       dropped2=[dropped2 points2];
       dropped2=unique(dropped2,'stable');
%        dropped3=[dropped3 round(a(1,2))];
%        dropped3=unique(dropped3,'stable');
       chk=[];
    end
else
    chk = [];
    points2=[];
    dropped2=[];
    dropped3=[];
    delete(findobj('tag','Rect2')); %delete last tool tip
    setappdata(handles.figure1,'selection_samples',[]);
end

h_i=getappdata(handles.figure1,'h_i');
a=get(h_i,'parent');
delete(findobj('tag','Rect_perm')); %delete last tool tip
for i=1:length(points2)
    rect=rectangle(a,'Position',[points2(i)-0.5 0 1 size(h_i.CData,1)+0.5],'EdgeColor','r');
    set(rect,'Tag','Rect_perm');
    set(rect,'PickableParts','none')
end

setappdata(handles.figure1,'points_hi',points2);
Show_Tissue_Selection_2(horzcat(clustMembsCell{points2}),handles);
Colocalization_details_environment_creation(handles,dropped2,dropped3);

