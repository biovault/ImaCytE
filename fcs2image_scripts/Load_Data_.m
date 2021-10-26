function Load_Data_(hObject, eventdata,flags,handles)

%% This callback initializes the Loading the data process

global cell4 % Each instance of cell4 is a different sample
global tsne_map % represents the calculated tsne_map
global n_data % represents the high dimensional data used for dimensionality reduction
global tsne_idx % keeps track of the sample each cell belongs to
global heatmap_selection
tsne_idx=0;
tsne_map=[];

if strcmp(eventdata.Source.Text,'Load Raw Images')
    answer2 = questdlg('Would you like an outlier removal function to be applied in the data?', ...
                'Outlier Removal', ...
                'Yes','No thank you','No thank you');
    switch answer2
        case 'Yes'
            flags(2)=1;
        case 'No thank you'
            flags(2)=0;
    end
end

mode='Imaging'; 
switch mode
    case 'Imaging'
        cell4=[];
        r=uigetdir();
        direct_=dir(r);
        f = waitbar(0,'Please wait...');
        if isempty(find(vertcat(direct_(3:end).isdir), 1))
            cell4=Load_Multiple_Images_IMACytE(r,flags,handles);
        else
            for i=3:length(direct_)
                if direct_(i).isdir
                    try
                        cell4=[cell4 ; Load_Multiple_Images_IMACytE([direct_(i).folder '\' direct_(i).name],flags,handles)];
                        waitbar((1/(length(direct_)-2)*(i-2)),f,['Loaded ' num2str(i-2) ' out of ' num2str(length(direct_)-2) ' images ']);
                    catch
                        warndlg(['Problem loading File: ' direct_(i).folder '\' direct_(i).name],'Error');
                    end
                end
            end
        end
        waitbar(1,f,'Finished');
        markers=cell4(1).cell_markers;
        setappdata(handles.figure1,'markers',markers);
end

%% tsne_idx initialization
n_data=double(vertcat(cell4(:).data));
prev=0;
for i=1:length(cell4)    
    tsne_idx(prev+1:prev+size(cell4(i).data,1))=i;
    prev=prev+ size(cell4(i).data,1);
end


all_markers=cell4(1).cell_markers;
setappdata(handles.figure1,'markers',all_markers);

set(handles.Markerlist,'String',all_markers);
set(handles.Markerlist,'Value',[]);

end

