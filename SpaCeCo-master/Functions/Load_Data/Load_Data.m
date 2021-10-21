function  Load_Data(~,~,handles,cmap,cluster_names)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global cell4
% global tsne_idx % keeps track of the sample each cell belongs to
global dragging
global find_selection
find_selection=1;
dragging = [];
% tsne_idx=0;
% cell4=[];

answer = inputdlg('Enter name of Cohort 1:','Cohort 1',[1 35],{'Cohort_1'});
[indx,tf] = listdlg('Name',answer{1},'PromptString','Select tissue samples:',...
'SelectionMode','multiple','ListSize',[200 300],...
'ListString',{cell4(:).name});
for i=1:length(indx); cell4(indx(i)).cohort=1; end

list_temp=setdiff(1:length(cell4),indx);
answer2 = inputdlg('Enter name of Cohort 2:','Cohort 2',[1 35],{'Cohort_2'});
[indx2,tf] = listdlg('Name',answer2{1},'PromptString','Select tissue samples:',...
'SelectionMode','multiple','ListSize',[200 300],...
'ListString',{cell4(list_temp).name});
for i=1:length(indx2); cell4(list_temp(indx2(i))).cohort=2; end

cohort_names={answer{1} ; answer2{1}};

% r=dir(uigetdir()); 
% f = waitbar(0,'Please wait...');
% for i=3:length(r)
%     folder_imgs=dir([r(i).folder '\' r(i).name '\*.tiff']);
%     for j=1:length(folder_imgs)
%         temp=Load_Only_masks([folder_imgs(j).folder '\' folder_imgs(j).name]);
%         temp.cohort=i-2;
%         try 
%             [number,txt]=xlsread([folder_imgs(j).folder '\' temp.name '.csv']);
%         catch
%             try
%                 [number,txt]=xlsread([folder_imgs(j).folder '\' temp.name(1:end-5) '.csv']);
%             catch
%                 errordlg(['Clusters for ' temp.name 'Have not been found' ]);
%             end
%         end
%         if length(txt)<2
%             if isequal(number(1),'Var1')
%                 temp.clusters=number(2:end)';
%             else
%                 temp.clusters=number(1:end)';
%             end
%         else
%             if isequal(txt{1},'Var1')
%                 temp.clusters=txt(2:end)';
%             else
%                 temp.clusters=txt(1:end)';
%             end
%         end
%         if ~isequal(length(temp.clusters),length(temp.idx))
%             errordlg(['Different number of cells among clusters and mask for ' temp.name ' sample'])
%         end
%         cell4=[cell4 ; temp];  
%         waitbar((1/(length(r)-2)*(i-2)),f,['Cohort: ' num2str(i-2) ' Loaded ' num2str(j) ' out of ' num2str(length(folder_imgs)) ' images ']);
%     end
%     cohort_names{i-2}=r(i).name;
% end

% prev=0;
% for i=1:length(cell4)
%     tsne_idx(prev+1:prev+length(cell4(i).idx))=i;
%     prev=prev+ length(cell4(i).idx);
% end
% 
% if iscell([cell4(:).clusters])
%     [cluster_names,~,cluster_ids]=unique([cell4(:).clusters]);
%     for i=1:length(cell4)
%         temp=cluster_ids(tsne_idx==i)';
%         cell4(i).clusters=temp;
%     end
% else
%     numClust=max(horzcat(cell4(:).clusters));
%     for i=1:numClust
%         cluster_names{i}=['Cluster' num2str(i)];
%     end
% end

handles=cell2clust(handles);
%%
numClust=numel(cluster_names);
%    
% colors=[141,211,199
% 255,255,179
% 190,186,218
% % 251,128,114  %red
% % 128,177,211  %blue
% 253,180,98   %orange
% 179,222,105
% 252,205,229
% 217,217,217
% 188,128,189
% 204,235,197
% 255,237,111];
% 
T=repmat(1:size(cmap,1),[1 ceil(numClust/size(cmap,1))]);
T=T(1:numClust);
% hsv_colors=rgb2hsv(colors/255);
% cmap=zeros(length(T),3);
% for i=1:max(T)
%     idxs=find(T==i);
%     if isempty(idxs)
%         continue;
%     elseif length(idxs)==1
%         temp=hsv_colors(i,:);
%     else
%         c=linspace(0.2,0.8,length(idxs))';
%         temp=[repmat(hsv_colors(i,1),length(idxs),1) c  repmat(hsv_colors(i,3),length(idxs),1)];
%     end
%     cmap(idxs,:)=temp;
% end
% cmap=hsv2rgb(cmap);

temp=cell4;
setappdata(handles.figure1,'original_data',temp);
setappdata(handles.figure1,'cohort_names',cohort_names);
setappdata(handles.figure1,'cluster_names',cluster_names);
setappdata(handles.figure1, 'colors_cluster', T);
setappdata(handles.figure1,'cmap',cmap);
setappdata(handles.figure1,'selection_samples',[]);

end

