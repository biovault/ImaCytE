function Cluster_blobs_ButtonDown(hObject,~,handles,position)

    global dropped2
    global dropped3
    persistent chk

    if isempty(chk)
        chk = 1;
        pause(0.5); %Add a delay to distinguish single click from a double click
        if chk == 1
            chk=[];
        end
    else
        cmap=getappdata(handles.figure1,'cmap');
        remove_idx=find(ismember(cmap,hObject.FaceColor));
        if position==1
            dropped2=setdiff(dropped2,remove_idx);
        elseif position ==2
            dropped3=setdiff(dropped3,remove_idx);
        end
        Colocalization_details_environment_creation(handles,dropped2,dropped3);
    end   
end