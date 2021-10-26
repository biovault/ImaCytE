function Cell_Abundance_Cohort_ButtonDown(hObject,~,handles)

    persistent chk
    h=getappdata(handles.figure1,'cell_type_fig');
    colors=getappdata(handles.figure1,'cohort_colors');
    transparency_param=0.2;
    temp=get(gcf);
    if isequal(temp.Name, 'Co-localization patterns')
        h=getappdata(handles.figure1,'colocalization_details');
    end
    if isempty(chk)
        chk = 1;
        pause(0.5); %Add a delay to distinguish single click from a double click
        if chk == 1
            w=findobj(h,'Tag','White_parts');
            for i=1:numel(w)
            w(i).FaceAlpha=0;
            end
            for j=1:size(colors,1)
                w=findobj(h,'FaceColor',colors(j,:),'-or','-regexp','Tag',[num2str(j) '$']);
                if colors(j,:)==hObject.FaceColor
                    for i=1:numel(w)
                        w(i).FaceAlpha=1;
                    end
                else
                    for i=1:numel(w)
                        w(i).FaceAlpha=transparency_param;
                    end
                end
            end            
            chk=[];
        end
    else
        for j=1:size(colors,1)
            w=findobj(h,'FaceColor',colors(j,:),'-or','Type','patch');
            for i=1:numel(w)
                w(i).FaceAlpha=1;
            end
        end
        w=findobj(h,'Tag','White_parts');
        for i=1:numel(w)
            w(i).FaceAlpha=1;
        end
        chk=[];
    end
end