function Image_Callback(hObject,event,norm_fac,handles)

% Callabck upon the selection of a specific cell either in the tsne map or
% in the samples when the cluster of the cells is visualized with the color channel
% used for the illustration of the data in the heatmap
%   - hObject: inherited from the location that is selected from the user,
%   either "Normalization", "Min/Max", "Actual values"
%   -event: inherited from the callback also provides information on the
%   kind of the selected functionality
%   -norm_fac: value representing the offset that is provided to the cells
%   of each sample
%   - point2cluster: a vector that saves the cluster for each cell id 
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox


global cell4
global tsne_idx
persistent text_
persistent chk
global p_
global  heatmap_selection

if event.Button ~=1; return; end
delete(text_)

if isempty(chk) 
    chk = 1;
    pause(0.5); %Add a delay to distinguish single click from a double click
    if chk == 1
        chk=[];
        
        if strcmp(class(hObject),'matlab.graphics.chart.primitive.Scatter')
            dist=bsxfun(@hypot,hObject.XData -event.IntersectionPoint(1),hObject.YData -event.IntersectionPoint(2));
            out= find(dist==min(dist));
            out=out+norm_fac;
        elseif strcmp(class(hObject),'matlab.graphics.primitive.Image')  
            delete(text_); %delete last tool tip
            temp=cell4(tsne_idx(norm_fac+1)).mask_cell;
            out=temp(floor(event.IntersectionPoint(2)),floor(event.IntersectionPoint(1)));
        end
        
        if out>0
            out=out+norm_fac;
            text_=text(get(hObject,'Parent'),event.IntersectionPoint(1),event.IntersectionPoint(2),['Cell:' num2str(out)],...
                    'backgroundcolor',[1 1 1],'tag','mytooltip','edgecolor',[1 1 1],...
                    'hittest','off','Fontsize',8); 
            p_=setxor(p_,out);
            point2cluster=horzcat(cell4(:).clusters);
            heatmap_selection=setxor(heatmap_selection,point2cluster(p_));
        end
    end
else
    chk = [];
    p_=[];
    heatmap_selection=[];
end

Show_Heatmap_Selection(heatmap_selection);
Show_Tissue_Selection(p_,handles);
Show_Scatter_Selection(p_,handles);

