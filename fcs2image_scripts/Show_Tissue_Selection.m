function Show_Tissue_Selection(list2,handles)

% Takes as argument the selected cells and highlights them in the images
% when the cluster of the cells is visualized with the color channel
%   - list2: the id's of the selected cells
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global cell4
global tsne_idx
global find_selection

if find_selection
    selection_samples=unique(tsne_idx(list2));
    setappdata(handles.figure1,'selection_samples',selection_samples);
    Update_Tissue(handles)
else
    selection_samples=getappdata(handles.figure1,'selection_samples');
end
transparency=0.2;

if isempty(selection_samples); return; end
for i=selection_samples
    norm_fac=find(tsne_idx == i,1)-1;
    myMembers = list2;
    myMembers= myMembers(tsne_idx(myMembers) == i) -norm_fac;

    bwmask=ones(size(cell4(i).mask_cell,1),size(cell4(i).mask_cell,2))*transparency;
    temp=cell4(i).idx(myMembers);
    temp=vertcat(temp{:});  

    bwmask(temp)=1;    
    
    mysum=getappdata(handles.figure1,[ 'image' num2str(i)]);
    set(mysum, 'AlphaData', bwmask); 
    if isempty(list2)
        set(mysum, 'AlphaData', 1); 
    else
        set(mysum, 'AlphaData', bwmask); 
    end
        imwrite(mysum.CData,  [  '\' cell4(i).name '_Clustered_data'  '.png'], 'Alpha',bwmask)

end


