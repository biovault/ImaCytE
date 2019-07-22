function Show_Tissue_Selection_cont(list2,handles)

% Takes as argument the selected cells and highlights them in the images
% when a specific feature of the cells is visualized with the color channel
%   - list_of_cells: the id's of the selected cells
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox
global cell4;
global tsne_idx;
global find_selection

selection_markers=getappdata(handles.figure1,'selection_markers');
if isempty(selection_markers); warndlg('Please select markers');   return; end
selection_markers=selection_markers-1;

if find_selection
    selection_samples=unique(tsne_idx(list2));
    setappdata(handles.figure1,'selection_samples',selection_samples);
    if selection_markers>length(cell4(1).cell_markers)
        Update_Tissue_Segmentation(handles);
    else
        Update_Tissue_Continious_var(handles)
    end
else
    selection_samples=getappdata(handles.figure1,'selection_samples');
end

if isempty(selection_samples); return; end
transparency=0.8;
counter=0;
for i=selection_samples
    for ii=selection_markers
        counter=counter+1;
        norm_fac=find(tsne_idx == i,1)-1;
        myMembers = list2;
        myMembers= myMembers(tsne_idx(myMembers) == i) -norm_fac;

        bwmask=ones(size(cell4(i).mask_cell,1),size(cell4(i).mask_cell,2))*transparency;
        temp=cell4(i).idx(myMembers);
        temp=vertcat(temp{:}); 
        bwmask(temp)=0;    
    
        mysum=getappdata(handles.figure1,[ 'image' num2str(counter)]);
        set(mysum, 'AlphaData', bwmask);

        if isempty(list2)
            set(mysum,'Visible','off')
        else
            set(mysum,'Visible','on')
        end

    end
end
