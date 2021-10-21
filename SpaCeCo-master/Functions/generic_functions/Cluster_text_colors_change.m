function Cluster_text_colors_change(hObject,~,handles)

% Callcack for the selection of a box in the bottom of the heatmap. With
% single click the annotation of a cluster can be achieved. With double
% click the change of the color.

%   Copyright 2020 Mirtech, Inc.
persistent chk

cluster_names = getappdata(handles.figure1, 'cluster_names');

if isempty(chk)
    chk = 1;
    pause(0.5); %Add a delay to distinguish single click from a double click
    if chk == 1
        chk=[];
        prompt={'Give a name for this cluster'};
        dlg_title='Cluster Annotation';
        num_lines=1;
        cluster_name_ans=inputdlg(prompt,dlg_title,num_lines);
        try 
            cluster_names{ismember(cluster_names,hObject.String)}=cluster_name_ans{1};     
            set(hObject,'String',cluster_name_ans{1}); 
        catch  
        end
        setappdata(handles.figure1, 'cluster_names',cluster_names);
    end
else
    chk=[];
    T=getappdata(handles.figure1, 'colors_cluster');
    cmap=getappdata(handles.figure1,'cmap'); 
    colors=[23 118 182 ;...
%         255 127 0 ; ...
        36 161 33; ...
        216 36 31 ; ...
        141 86 73 ; ...
        229 116 195;...
        149 100 191; ...
%         0 190 208;...
        188 191 0;...
        127 127 127];
    colors=[141,211,199
            255,255,179
            190,186,218
%             251,128,114  %red
%             128,177,211  %blue
            253,180,98   %orange
            179,222,105
            252,205,229
            217,217,217
            188,128,189
            204,235,197
            255,237,111];
        
     hsv_colors=rgb2hsv(colors/255);
     colors_=Color_Selection;   
     temp_idx=ismember(cluster_names,hObject.String);
     T(temp_idx)=colors_;
     cmap=zeros(length(T),3);
     for i=1:max(T)
        idxs=find(T==i);
        if isempty(idxs)
            continue;
        end
        if length(idxs)==1
           temp=hsv_colors(i,:);
        else
            c=linspace(0.3,0.7,length(idxs))';
            temp=[repmat(hsv_colors(i,1),length(idxs),1) c repmat(hsv_colors(i,3),length(idxs),1)];
         end
         cmap(idxs,:)=temp;
     end
     cmap=hsv2rgb(cmap);
     setappdata(handles.figure1, 'cmap', cmap);
     setappdata(handles.figure1, 'colors_cluster', T);
     set(hObject,'Color',cmap(temp_idx,:));
end
