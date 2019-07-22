function Scatter_Context_Menu(source,~,handles)

% Callback upon selection of of a brushing an area in the scatter plot 
%   - source: inherited from the varaible that is selected from the user,
%   either "Normalization by row", "Normalization by column", "Normalization excluding diagonal"
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

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
    end
  
