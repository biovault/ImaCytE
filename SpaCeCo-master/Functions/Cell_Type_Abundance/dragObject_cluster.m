function dragObject_cluster(hObject,rt,i)
global dragging
global orPos
global dropped

persistent chk
if rt.Button ~=1; return; end

    if isempty(chk)
        chk = 1;
        pause(0.5); %Add a delay to distinguish single click from a double click
        if chk == 1
            chk=[];
            dropped=[dropped i];
            dropped=unique(dropped);
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
    

       
