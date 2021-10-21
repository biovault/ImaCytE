function dragObject_coloc(hObject,rt,handles)
global dragging
global orPos
global generic_dropped

persistent chk
if rt.Button ~=1; return; end

    if isempty(chk)
        chk = 1;
        pause(0.5); %Add a delay to distinguish single click from a double click
        if chk == 1
            chk=[];
            cluster_names=getappdata(handles.figure1,'cluster_names');
            temp=find(ismember(cluster_names,hObject.YLabel.String));
            if isempty(temp); return; end
            generic_dropped=temp;
            new=copyobj(hObject,get(hObject,'Parent'));
            dragging = new;
            orPos = get(gcf,'CurrentPoint');
        end
    else
            f=figure; 
            new_axes=axes(f);
            set(new_axes,'Visible','off');
            temp=get(hObject,'Parent');
            new1=copyobj(hObject,temp);
            new1.Position=new_axes.Position;
            new1.Parent=f;        
        chk=[];
    end