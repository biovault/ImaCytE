function Image_Context_Menu(source,~,num,handles)

% Callback upon selection of of a brushing an area in an Image 
%   - source: inherited from the varaible that is selected from the user,
%   either "Normalization by row", "Normalization by column", "Normalization excluding diagonal"
%   - num: Number of the selected image sample
%   - handles: variable with all the handlers and saved variables of the
%   environment
%   - point2cluster: a vector that saves the cluster for each cell id 

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox


    global cell4;
    global tsne_idx;
    global p_
    global heatmap_selection

    value1=getappdata(handles.figure1,'selection_markers');
    value1=value1(1);
    switch source.Label
        case 'Brush'
                zoom off;
                pan off;
                rotate3d off;
                datacursormode off;
                tissue=getappdata(handles.figure1, [ 'Tissue_axes' num2str(num)]);
                hold(tissue,'on')
                w=scatter(tissue,cell4(num).cells_centre(:,1),cell4(num).cells_centre(:,2));
                set(w,'MarkerEdgeAlpha',0)
                hold(tissue,'off')
                axes(tissue)
                try
                   p = selectdata('SelectionMode','lasso');
                   p=p{1};
                   delete(w)
                   norm_fac=find(tsne_idx == num,1)-1;
                   p=p+norm_fac;
                   p_=setxor(p_,p);
                   if value1<2
                       clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
                       numClust=length(clustMembsCell);
                       for i=1:numClust
                            point2cluster(clustMembsCell{i})=i;
                        end
                        heatmap_selection=[ heatmap_selection unique(point2cluster(p_))];
                        Show_Heatmap_Selection(heatmap_selection);
                        Show_Tissue_Selection(p_,handles);
                        Show_Scatter_Selection(p_,handles);
                   else
                        Show_Tissue_Selection_cont(p_,handles);
                        Show_Scatter_Selection_cont(p_,handles);
                   end
                catch
                end
                
                set(handles.figure1,'windowbuttonmotionfcn',@mousemove);
            
    end
  