function Colocalization_details_environment_creation(handles,cluster_of_interest,cluster_of_micro)

global cell4
global tsne_idx
global values_selection
hfig=getappdata(handles.figure1,'colocalization_details');
delete(findobj(hfig,'Tag','axes_coloc'));
try  delete(getappdata(handles.figure1,'axes_coloc')); catch ; end
try  delete(getappdata(handles.figure1,'Annotations')); catch ; end
try  delete(getappdata(handles.figure1,'axes_temp')); catch ; end

if isempty(cluster_of_interest) && isempty(cluster_of_micro)
    return
end

setappdata(handles.figure1,'cluster_of_micro',cluster_of_micro);
cluster_names=getappdata(handles.figure1, 'cluster_names');
cmap=getappdata(handles.figure1, 'cmap');

norm_neigh=getappdata(handles.figure1,'norm_neigh_list');
norm_neigh=vertcat(norm_neigh{:});
num_clusters=size(norm_neigh,2);
possible_micro_clusters=setdiff(1:num_clusters,cluster_of_micro);
per_sample_values=zeros(numel(cell4),numel(possible_micro_clusters)+2);
idxs=cell(numel(cell4),numel(possible_micro_clusters)+2);

for i=1:numel(cell4)
    temp=norm_neigh(tsne_idx==i,:)>0;
    temp_idx=find(tsne_idx==i);
    if ~isempty(cluster_of_interest)
        temp=temp(ismember(cell4(i).clusters,cluster_of_interest),:);
        temp_idx=temp_idx(ismember(cell4(i).clusters,cluster_of_interest));
    end
    if ~isempty(cluster_of_micro)
        temp2_idx=all(temp(:,cluster_of_micro),2);
    else
        temp2_idx=1:numel(temp_idx);
    end
    idxs{i,1}=temp_idx(all(temp(:,cluster_of_micro),2));
    per_sample_values(i,1)=numel(idxs{i,1});
    idxs{i,2}=temp_idx(any(temp(temp2_idx,possible_micro_clusters),2)==0);
    per_sample_values(i,2)=numel(idxs{i,2});
    for j=1:numel(possible_micro_clusters)
        idxs{i,j+2}=temp_idx(temp(temp2_idx,possible_micro_clusters(j)));
        per_sample_values(i,j+2)=numel(idxs{i,j+2});
    end
end

setappdata(handles.figure1,'per_sample_coloc',per_sample_values);
if values_selection ==1
    per_image_clusters=getappdata(handles.figure1,'per_image_clusters');
    per_sample_values=per_sample_values./sum(per_image_clusters,2);
end  

num_cohorts=max([cell4(:).cohort]);
per_image_cluster_ids=cell(num_cohorts,numel(possible_micro_clusters)+2);
for i=1:num_cohorts
    for j=1:numel(possible_micro_clusters)+2
        per_image_cluster_ids{i,j}=per_sample_values(ismember([cell4(:).cohort],i),j);
    end
end
%% Environment creation
num_subplots=5;
diff_param=0.4; %0.6

% subplot = @(n) subtightplot (num_subplots,1,  n, [0.04 0.05], [0.05 0.05], [0.05 0.05]);
for i=1:numel(cluster_of_interest)
    a(i,1)=annotation(hfig,'ellipse','units','normalized','position',[0.1+(i-1)*0.10 0.92 0.08 0.08*diff_param],'FaceColor',cmap(cluster_of_interest(i),:),'ButtonDownFcn',{@Cluster_blobs_ButtonDown,handles,1});
end

for i=1:numel(cluster_of_micro)
    a(i,2)=annotation(hfig,'ellipse','units','normalized','position',[0.1+(i-1)*0.10 0.82 0.08 0.08*diff_param],'FaceColor',cmap(cluster_of_micro(i),:),'ButtonDownFcn',{@Cluster_blobs_ButtonDown,handles,2});
end
setappdata(handles.figure1,'Annotations',a);
ax_temp=axes(hfig,'Position',[0.1 0.68 0.8 0.12],'Tag','Coloc_axes');
setappdata(handles.figure1,'axes_temp',ax_temp);
set(ax_temp,'ButtonDownFcn',{@droped_axes_ButtonDown})
my_density_graph(handles,ax_temp,per_image_cluster_ids(:,1),'',[0 0 0],1);


tab=getappdata(handles.figure1,'tabgroup');

total_num=numel(possible_micro_clusters)+1;
temp_pos=zeros(total_num,4);
temp_tab=cell(total_num);
for i=1:total_num
        ax_=axes(tab{ceil(i/num_subplots)});
        if mod(i,num_subplots) == 0
            ax(i)=subplot (num_subplots,1,num_subplots,ax_,'Tag','Coloc_axes');
%             ax(i)=subplot(num_subplots);
        else
            ax(i)=subplot (num_subplots,1,mod(i,num_subplots),ax_,'Tag','Coloc_axes');
%             ax(i) = subplot(mod(i,num_subplots));
        end
        if i==1
            my_density_graph(handles,ax(i),per_image_cluster_ids(:,2),'None',[0 0 0],2);
        else
            my_density_graph(handles,ax(i),per_image_cluster_ids(:,i+1),cluster_names{possible_micro_clusters(i-1)},cmap(possible_micro_clusters(i-1),:),i+1);
        end
        temp_pos(i,:)=get(ax(i),'Position');
        temp_tab{i}=tab{ceil(i/num_subplots)};
        set(ax(i),'Parent',temp_tab{i});
        set(ax(i),'ButtonDownFcn',{@dragObject_coloc,handles});
end

setappdata(handles.figure1,'initial_pos_coloc',temp_pos);
setappdata(handles.figure1,'initial_tab_coloc',temp_tab);
setappdata(handles.figure1,'axes_coloc',ax);
setappdata(handles.figure1,'coloc_idxs',idxs);
