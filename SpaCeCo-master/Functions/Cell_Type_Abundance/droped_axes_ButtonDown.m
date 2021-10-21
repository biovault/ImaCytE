function droped_axes_ButtonDown(hObject,~)

global dropped
persistent chk

    if isempty(chk)
        chk = 1;
        pause(0.5); %Add a delay to distinguish single click from a double click
        if chk == 1
            chk=[];
            f=figure; 
            new_axes=axes(f);
            set(new_axes,'Visible','off');
            temp=get(hObject,'Parent');
            new1=copyobj(hObject,temp);
            new1.Position=new_axes.Position;
            new1.Parent=f;
        end
    else
        dropped=[];
        delete(hObject);
        chk=[];
    end
