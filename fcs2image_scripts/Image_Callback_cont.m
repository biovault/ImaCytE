function Image_Callback_cont(hObject,event,norm_fac,handles)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global cell4
global tsne_idx
persistent text_
persistent chk
global p_

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
            colormap(viridis);
        end
    end
else
    chk = [];
    p_=[];
end
Show_Tissue_Selection_cont(p_,handles);
Show_Scatter_Selection_cont(p_,handles);

