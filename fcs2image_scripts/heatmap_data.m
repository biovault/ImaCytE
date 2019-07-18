function heatmap_data(handles)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global n_data

f=getappdata(handles.figure1,'Heatmap_Figure');
temp=get(f,'Children');
delete(temp);

popup=uicontrol( f,'Style', 'popup',...
           'String', {'Normalize','Min_Max','Actual Values'},...
           'Position', [0.01 0 0.12 0.07],'Units','normalized',...
           'Callback', {@heatmap_data_Callback,handles}); 
set(popup,'Position',[0.92 0.9 0.07 0.07]);

clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
cluster_names=getappdata(handles.figure1, 'cluster_names');
cmap=getappdata(handles.figure1,'cmap');

markers=getappdata(handles.figure1,'markers');
markerlist=getappdata(handles.figure1,'selected_markers');
markers=markers(markerlist)';

numClust=length(clustMembsCell);
fin_mat=zeros(length(markerlist),numClust);
for i=1:numClust
    temp=median(n_data(clustMembsCell{i},markerlist))';
    fin_mat(:,i)=temp;
end

% fin_mat=[fin_mat n_data(p_,markerlist)];
% cmap=[cmap ;[ 0 0 0]];
% cluster_names=[ cluster_names ; {'Selection'}];

n=my_normalize(fin_mat,'row'); %standardize per row

% n=norm_single_column( fin_mat,0,1);

% figure; heatmap(fin_mat, cluster_names, markers, [], 'TickAngle', 60,'ShowAllTicks', true,'Colormap', viridis);
% figure; my_bar(ones(size(fin_mat,2),1),[],cmap);

ax_dendr=axes(f);
axes(ax_dendr)
[tree,leafOrder]=dendro_calculator(n);


% clustMembsCell=clustMembsCell(leafOrder);
% cluster_names=cluster_names(leafOrder);
% cmap=cmap(leafOrder,:);
% fin_mat=fin_mat(:,leafOrder);
% setappdata(handles.figure1,'leafOrder',leafOrder);

% setappdata(handles.figure1, 'clustMembsCell', clustMembsCell);
% setappdata(handles.figure1, 'cluster_names', cluster_names);
% setappdata(handles.figure1, 'cmap', cmap);

dendr=dendrogram(tree,100,'Reorder',leafOrder); %,'ColorThreshold',0.65*max(tree(:,3)));
set(dendr,'ButtonDown',{@dendroCallBack,handles})
set(ax_dendr, 'visible', 'off')
set(ax_dendr,'xlim',[0.5 size(fin_mat,2)+0.5])
set(ax_dendr,'Position',[0.08 0.89 0.82 0.11]);


ax_=axes(f);
axes(ax_)
h=my_heatmap(n, cluster_names, markers, [], 'TickAngle', 60,'ShowAllTicks', true,'Colormap', viridis);
c=colorbar;
caxis(ax_,[min(n(:)) max(n(:))])
set(h,'Tag','h_hd')
set(c,'ButtonDown',{@colormapCallBack,ax_})
set(h,'ButtonDown',{@nodeCallback,clustMembsCell,handles})

popup=uicontrol( f,'Style', 'popup',...
           'String', {'Normalize','Min_Max','Actual Values'},...
           'Position', [0.01 0 0.12 0.07],'Units','normalized',...
           'Callback', {@heatmap_data_Callback,ax_,fin_mat}); 
set(popup,'Position',[0.92 0.9 0.07 0.07]);

ax_cell_Pheno=axes(f);
rw4=my_bar(ones(size(fin_mat,2),1),[],cmap,ax_cell_Pheno);
set(ax_cell_Pheno, 'visible', 'off')
set(ax_cell_Pheno,'xlim',[0.5 size(fin_mat,2)+0.5])
set(rw4,'BarWidth',1)
set(rw4,'ButtonDownFcn',{@nodeCallback_axes,handles});
set(ax_cell_Pheno,'Position',[0.08 0 0.82 0.10]);


d = uicontextmenu;
uimenu('Parent',d,'Label','Merge Selected Clusters','Callback',{@Heatmap_Context_menu,handles});
% uimenu('Parent',d,'Label','Annotate Selected Cluster','Callback',{@Heatmap_Context_menu,handles});
% uimenu('Parent',d,'Label','Change Color','Callback',{@Heatmap_Context_menu,handles});

set(h,'UIContextMenu',d);    
set(ax_,'Position',[0.08 0.10 0.82 0.79]);


function nodeCallback(hObject,rt,clustMembsCell,handles)

global p_
global heatmap_selection
persistent chk

selection_markers=getappdata(handles.figure1,'selection_markers');

if rt.Button ~=1; return; end
a=get(hObject,'Parent');
a=get(a,'currentpoint');
a=floor(a(1,1))+1;
if a>size(hObject.CData,2)
    a=size(hObject.CData,2);
end

heatmap_selection=setxor(heatmap_selection,a);
if isempty(chk) && ~isempty(heatmap_selection)
    chk = 1;
    pause(0.5); %Add a delay to distinguish single click from a double click
    if chk == 1
       chk=[];
    end
else
    chk = [];
    p_=[];
    heatmap_selection=[];
end
Show_Heatmap_Selection(heatmap_selection)
if selection_markers==1
    Show_Tissue_Selection(horzcat(clustMembsCell{heatmap_selection}),handles);
    Show_Scatter_Selection(horzcat(clustMembsCell{heatmap_selection}),handles);
else
    Show_Tissue_Selection_cont(horzcat(clustMembsCell{heatmap_selection}),handles);
    Show_Scatter_Selection_cont(horzcat(clustMembsCell{heatmap_selection}),handles);
end 

function nodeCallback_axes(hObject,~,handles)

persistent chk

if isempty(chk)
    chk = 1;
    pause(0.5); %Add a delay to distinguish single click from a double click
    if chk == 1
        prompt={'Give a name for this cluster'};
        dlg_title='Cluster Annotation';
        num_lines=1;
        cluster_name_ans=inputdlg(prompt,dlg_title,num_lines);
        cluster_names = getappdata(handles.figure1, 'cluster_names');
        try cluster_names{hObject.XData}=cluster_name_ans{1}; catch ; end
        setappdata(handles.figure1, 'cluster_names',cluster_names);
        chk=[];
    end
else
    T=getappdata(handles.figure1,'h_cluster');
     colors=[23 118 182 ;...
        255 127 0 ; ...
        36 161 33; ...
        216 36 31 ; ...
        141 86 73 ; ...
        229 116 195;...
        149 100 191; ...
        0 190 208;...
        188 191 0;...
        127 127 127];
    
     hsv_colors=rgb2hsv(colors/255);
     colors_=Color_Selection;        
     T(hObject.XData)=colors_;
     cmap=zeros(length(T),3);
     for i=1:max(T)
        idxs=find(T==i);
        if isempty(idxs)
            continue;
        end
        if length(idxs)==1
           temp=hsv_colors(i,:);
        else
        %     [~,c]=kmeans(nchoosek([0.4:0.01:1],2),length(idxs));
        %     temp=[repmat(hsv_colors(i,1),length(idxs),1) c(:,1)  c(:,2)];
            [~,c]=kmeans([0.1:0.01:1]',length(idxs));
            temp=[repmat(hsv_colors(i,1),length(idxs),1) c  repmat(hsv_colors(i,3),length(idxs),1)];
         end
         cmap(idxs,:)=temp;
     end
     cmap=hsv2rgb(cmap);
     setappdata(handles.figure1, 'cmap', cmap);
     setappdata(handles.figure1, 'h_cluster', T);
     chk=[];
end

heatmap_data(handles)
Update_Tissue(handles); 
Update_Scatter(handles); 



        

