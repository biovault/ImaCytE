function Colocalization_environment_creation(~,~,handles)

global cell4
global tsne_idx
global values_selection             
values_selection=1;

num_of_samples=length(cell4);

h = figure('WindowButtonUpFcn',{@dropObject_colocalization,handles},'units','normalized','WindowButtonMotionFcn',@moveObject,'units','normalized','outerposition',[0 0 1 1],'Name','Co-localization patterns','NumberTitle','off','Color','White');

%% Identifying the distance that defines microenvironment
prompt={'Distnace (in pixels) that makes 2 cells adjacent'};
dlg_title='Input';
num_lines=1;
defaultans={'5'};
x=inputdlg(prompt,dlg_title,num_lines,defaultans);
number_of_pixels=str2num(x{:}); 
for i=1:num_of_samples
    [cell4(i).neighlist]=neighlist_creation(cell4(i),number_of_pixels)';
end

%%
numClust=max(horzcat(cell4(:).clusters));
max_number_neighbors=max(cellfun('size',[cell4(:).neighlist],1));
num_cohorts=max([cell4(:).cohort]);
for j=1:num_cohorts
%% Assigns to a row of a matrix the neighbors of each cell
    temp_cell=cell4(ismember([cell4(:).cohort],j));
    ag_neigh=horzcat(temp_cell(:).neighlist);
    point2cluster=horzcat(temp_cell(:).clusters);
    temp_idx=[];
    for i=1:length(temp_cell)
            temp_idx=[ temp_idx ones(1,length(temp_cell(i).idx))*i];
    end
    clusteri{j}=zeros(length(ag_neigh),max_number_neighbors);
    for i=1:length(ag_neigh)
        norm_fac=find(temp_idx == temp_idx(i),1)-1;  
        temp=ag_neigh{i}+norm_fac;
        temp(temp == norm_fac)=0;
        clusteri{j}(i,1:length(ag_neigh{i}))=temp;
    end
    tmp=clusteri{j}+1;
    tmp2=[0 point2cluster];
    cluster_of_neigh_cells=tmp2(tmp);

    %% Calculates a matrix where each row represents the relative frequency of a cell to colocalize with a cluster
    n_neigh=zeros(length(ag_neigh),numClust);
    for i=1:length(ag_neigh)
        tmp=cluster_of_neigh_cells(i,:);
        tmp(tmp==0)=[];
        if isempty(tmp); continue; end
        a_counts = accumarray(tmp(:),1);
        n_neigh(i,1:length(a_counts))=a_counts;
    end
    norm_neigh{j}=n_neigh./sum(n_neigh,2);
    norm_neigh{j}(isnan(norm_neigh{j}))=0;

    %% Calculate the relative frequency of colocalization among the clusters 
    cooc{j}=zeros(numClust);
    cooc2{j}=zeros(numClust);

    for i=1:numClust
        tmp=n_neigh(point2cluster==i,:);
        if size(tmp,1)==1
            cooc{j}(i,:)=tmp;
        else
            cooc{j}(i,:)=sum(tmp);
        end
        tmp=tmp>0;
        if size(tmp,1)==1
            cooc2{j}(i,:)=tmp;
        else
            cooc2{j}(i,:)=sum(tmp);
        end
    end
    new_cooc{j}=cooc2{j}./sum(cooc2{j},1);
    new_cooc{j}(isnan(new_cooc{j}))=0;
end
temp=[0 cumsum(cellfun(@(x) size(x,1),clusteri,'uni',1))];
for i=1:length(clusteri)
    clusteri{i}=clusteri{i}+temp(i);
    temp_mat=zeros(size(clusteri{i},1),max(cellfun(@(x) size(x,2),clusteri,'uni',1))-size(clusteri{i},2));
    clusteri{i}=[clusteri{i} temp_mat];
end
setappdata(handles.figure1,'new_cooc',new_cooc);
setappdata(handles.figure1,'clusteri',clusteri);
setappdata(handles.figure1,'cooc_overall',cooc);
setappdata(handles.figure1,'cooc_overall_uni',cooc2);
setappdata(handles.figure1,'norm_neigh_list',norm_neigh);

%% The interaction heatmap is created
% hfig1 = figure('units','normalized','outerposition',[0 0 1 1],'Name','Tissue Samples','NumberTitle','off','Color','White');
hfig1 = uipanel('Parent',h,'Title',[''],'FontSize',18,'ForegroundColor',[ 1 1 1],...
             'BackgroundColor','white',...
             'Position',[0 0 0.5 1]);
set(hfig1,'Tag','heatmap_int')

metrics={'Mean difference','Silhouette','Davies-Bouldin','Calinski-Harabasz','Krzanowski- Lai','Dunn','Bhattacharyya','DTW','Clustering validity index'};
indx= listdlg('ListString',metrics,'SelectionMode','single','PromptString','Select differentiation metric');
if indx ==1
    Interaction_heatmap_2(hfig1,new_cooc{1}-new_cooc{2},accumarray(horzcat(cell4(:).clusters)',1),handles, vertcat(clusteri{:}));
else
    indx=indx-1;
    norm_neigh=vertcat(norm_neigh{:}); tot_num=cell(numClust,numClust); tot_num2=cell(numClust,numClust);
    for i=1:numel(cell4)
        for cluster_of_interest=1:numClust
            temp=norm_neigh(tsne_idx==i,:)>0;
            temp_idx=find(tsne_idx==i);
            try
                temp=temp(ismember(cell4(i).clusters,cluster_of_interest),:);
            catch
                tic;
            end
            temp_idx=temp_idx(ismember(cell4(i).clusters,cluster_of_interest));
            cell4(i).neighbor_idxs{cluster_of_interest,1}=temp_idx(any(temp,2)==0);
            for cluster_of_micro=1:numClust
                cell4(i).neighbor_idxs{cluster_of_interest,cluster_of_micro}=temp_idx(temp(:,cluster_of_micro));
                tot_num{cluster_of_micro,cluster_of_interest}=[tot_num{cluster_of_micro,cluster_of_interest} numel(temp_idx(temp(:,cluster_of_micro)))];
                tot_num2{cluster_of_micro,cluster_of_interest}=[tot_num2{cluster_of_micro,cluster_of_interest} numel(temp_idx(temp(:,cluster_of_micro)))/length(cell4(i).clusters)];
            end
        end
    end
    for i=1:size(tot_num,1)
        for j=1:size(tot_num,2)
            tt(i,j)=valid_clusterIndex(tot_num2{i,j}',[cell4(:).cohort],indx);
        end
    end
    Interaction_heatmap_2(hfig1,tt,accumarray(horzcat(cell4(:).clusters)',1),handles, vertcat(clusteri{:}));
end
d = uicontextmenu(get(hfig1,'Parent'));
uimenu('Parent',d,'Label','Save_as','Callback',{@Save_as_Context_Menu, hfig1});
set(hfig1,'UIContextMenu',d);

%% Detailed exploration

hfig3 = uipanel('Parent',h,'Title',['Detailed exploration' ],'FontSize',18,'ForegroundColor',[ 0 0 0],...
             'BackgroundColor','white',...
             'Position',[0.5 0 0.5 1]);

%Create tabgroup
num_subplots=5;
tabgp = uitabgroup(hfig3,'units','normalized','outerposition',[0 0 1 0.65]);
total_num=ceil((numClust+1)/num_subplots);
tab=cell(1,total_num);
for i=1:total_num
    tab{i}=uitab(tabgp,'Title',num2str(i));
    set(tab{i},'BackgroundColor',[1 1 1]);
    try 
        d = uicontextmenu(get(hfig,'parent'));
        uimenu('Parent',d,'Label','Save_as','Callback',{@Save_as_Context_Menu, hfig, handles});
        set(tab{i},'UIContextMenu',d);
    catch
    end
end
setappdata(handles.figure1,'tabgroup',tab);

% Create order selection functionality
bg = uibuttongroup(hfig3,'Visible','off',...
                  'Position',[0.13 0.005 0.78 0.035],...
                  'BackgroundColor',[1 1 1],... 
                  'Title','Reordering');  
              
Ascending_button = uicontrol(bg,'Style',...
                  'radiobutton',...
                  'String','Ascending',...
                  'BackgroundColor',[1 1 1],...
                  'Value',0,...
                  'Callback', {@Cell_Coloc_Selection_CallBack,handles});
Ascending_button.Units= 'normalized';
Ascending_button.Position= [0.6 0.2 0.2 0.8];
Ascending_button.Enable='off';

Descending_button = uicontrol(bg,'Style','radiobutton',...
                  'String','Descending',...
                  'BackgroundColor',[1 1 1],...
                  'Value',1,...
                  'Callback', {@Cell_Coloc_Selection_CallBack,handles});
Descending_button.Units= 'normalized';            
Descending_button.Position= [0.8 0.2 0.2 0.8];
Descending_button.Enable='off';

metrics={'Silhouette','Davies-Bouldin','Calinski-Harabasz','Krzanowski- Lai','Dunn','Bhattacharyya','DTW','Clustering validity index'};
Metrics = uicontrol( bg,'Style', 'popup',...
           'String', metrics,...
           'Callback', {@Cell_Coloc_Selection_CallBack,handles}); 
set(Metrics,'Units','normalized')
set(Metrics,'Position',[0.3 0.2 0.25 0.8]);
Metrics.Enable='off';
Metrics.Tag='Metrics';


Seperability_checkbox = uicontrol( bg,'Style', 'checkbox',...
           'String', 'Seperability metric',...
           'BackgroundColor',[1 1 1],... 
           'Callback', {@Cell_Coloc_Selection_CallBack,handles}); 
set(Seperability_checkbox,'Units','normalized')
set(Seperability_checkbox,'Position',[0 0.1 0.3 0.8]);
bg.Visible = 'on';

%Create values representation selection
bg1 = uibuttongroup(hfig3,'Visible','off',...
                  'Position',[0.03 0.585 0.4 0.035],...
                  'BackgroundColor',[1 1 1],... 
                  'Title','Values');

Absolute = uicontrol(bg1,'Style',...
                  'radiobutton',...
                  'String','Absolute',...
                  'BackgroundColor',[1 1 1],...
                  'Callback', {@Cell_Coloc_Selection_CallBack,handles});
Absolute.Units= 'normalized';
Absolute.Position= [0 0.2 0.5 0.8];
Relative = uicontrol(bg1,'Style','radiobutton',...
                  'String','Relative',...
                  'BackgroundColor',[1 1 1],...
                  'Value',1,...
                  'Callback', {@Cell_Coloc_Selection_CallBack,handles});
Relative.Units= 'normalized';            
Relative.Position= [0.5 0.2 0.5 0.8];
bg1.Visible = 'on';


%Create search selection funcitonality
popup = uicontrol( hfig3,'Style', 'edit',...
           'String', {'Search here a cell type'},...
           'Callback', {@Cell_Coloc_Selection_CallBack,handles}); 
set(popup,'Units','normalized')
set(popup,'Position',[0.45 0.585 0.25 0.03]);

%Create cell types construction environment
annotation(hfig3,'line',[0.1 0.9],[0.9 0.9]);
b=axes(hfig3,'Position',[0.06 0.91 0.001 0.08]);
set(b,'YTick',[]);
ylabel('Center');
b=axes(hfig3,'Position',[0.06 0.81 0.001 0.08]);
set(b,'YTick',[]);
ylabel({'Microenvironment'});

setappdata(handles.figure1,'colocalization_details',hfig3);

set(h,'windowbuttonmotionfcn',{@mousemove_interaction_2,handles});