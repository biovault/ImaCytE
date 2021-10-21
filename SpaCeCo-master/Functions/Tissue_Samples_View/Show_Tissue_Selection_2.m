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

if isempty(getappdata(handles.figure1,'tissue_samples')) 
    return 
elseif     ~isvalid(getappdata(handles.figure1,'tissue_samples'))
    return
end

if find_selection
    selection_samples=unique(tsne_idx(list2));
    selection_samples2=idx_2_cohort_idx(selection_samples);
    setappdata(handles.figure1,'selection_samples',selection_samples2);
    Update_Tissue_2(handles)
else
    selection_samples=getappdata(handles.figure1,'selection_samples');
    selection_samples=cohort_idx_2_idx(selection_samples);
end
transparency=0.10;
        
if isempty(selection_samples); return; end
for i=selection_samples
    norm_fac=find(tsne_idx == i,1)-1;
    myMembers = list2;
    myMembers= myMembers(tsne_idx(myMembers) == i) -norm_fac;
    
 
    bwmask=cell4(i).mask_cell;
    bwmask(:)=transparency;
    temp=cell4(i).idx(myMembers);
    bwmask(vertcat(temp{:}))=1; 
%     bwmask(ismember(cell4(i).mask_cell,myMembers)==1)=1;
    
    mysum=getappdata(handles.figure1,[ 'image' num2str(i)]);
    set(mysum, 'AlphaData', bwmask); 
    if isempty(list2)
        set(mysum, 'AlphaData', 1); 
    else
        set(mysum, 'AlphaData', bwmask); 
    end
%         imwrite(mysum.CData,  [  '\' cell4(i).name '_Clustered_data'  '.png'], 'Alpha',bwmask)
end


