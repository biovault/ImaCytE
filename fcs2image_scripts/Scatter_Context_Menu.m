function Scatter_Context_Menu(source,evnt,handles)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

    global cell4;
    global tsne_idx;
    global tsne_map;
    global p_
    global heatmap_selection
    axes_=findobj('Tag','Scatter_axes');
    clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
    numClust=length(clustMembsCell);
    for i=1:numClust
        point2cluster(clustMembsCell{i})=i;
    end
    value1=getappdata(handles.figure1,'selection_markers');
    value1=value1(1);
    switch source.Label
        case 'Merge whole clusters'
                    axes(axes_)
                    zoom off;
                    pan off;
                    rotate3d off;
                    datacursormode off;
%                     put('selected_position',[]);
                    p1=selectdata('SelectionMode','Closest');
                    p2=selectdata('SelectionMode','Closest');
                    p1=fliplr(~cellfun(@isempty,p1)');
                    p2=fliplr(~cellfun(@isempty,p2)');
%                     p1=find(~cellfun(@isempty,p1));
%                     p2=find(~cellfun(@isempty,p2));
                    new=clustMembsCell([find(p1) find(p2)]);
                    new=horzcat(new{:});
                    clustMembsCell{p2}=[];    % prwta to 2o ,se periptwsi pou p1 einai idio me p2 na min maurisoun ola ta cells
                    clustMembsCell{p1}=new;
                    clustMembsCell=clustMembsCell(~cellfun('isempty',clustMembsCell));
                    setappdata(handles.figure1, 'clustMembsCell', clustMembsCell)
                    
                    Update_Scatter_Tissue(cell4,tsne_map,handles,tsne_idx);
                    heatmap_data(handles)
        case 'P.Select'
                axes(axes_)
                zoom off;
                pan off;
                rotate3d off;
                datacursormode off;
                if value1<2
                    Update_Scatter_Tissue(handles);
                else
                    Update_Scatter_Tissue_Continious_var(handles); 
                end
        case 'P.Hoover'
        case 'Brush'
                axes(axes_)
                zoom off;
                pan off;
                rotate3d off;
                datacursormode off;
                axes(axes_)
                try
                   p = selectdata('SelectionMode','lasso');
                   p=p{1};
                   p_=setxor(p_,p);
                   if value1<2
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
        case 'C.Select'
        case 'C.Hoover'
        case 'C.Brush'
            axes(axes_)
            zoom off;
            pan off;
            rotate3d off;
            datacursormode off;

            clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');
            Update_Scatter_Tissue(cell4,tsne_map,handles,tsne_idx,false);
            p=selectdata('SelectionMode','Closest');
            p=fliplr(~cellfun(@isempty,p)');
            Show_Tissue_Selection(clustMembsCell{p},handles)
            
    end
  
