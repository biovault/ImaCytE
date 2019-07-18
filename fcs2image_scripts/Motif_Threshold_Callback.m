function Motif_Threshold_Callback(source,~,hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I2)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

persistent previous
global val

pause(1);
val=get(source,'Value');
if isequal(val,previous)
    temp=getappdata(handles.figure1,'First_val');
    val=temp;
    return
else
    previous=val;
end

sizes_=cellfun(@(x) length(x),idx_motif_cells,'UniformOutput' ,false);
sizes_=cell2mat(sizes_);
checked_rows2= sizes_ >= val;
I=checked_rows2;
fr=fr(I);
z=z(I);
motifs=motifs(I,:);
idx_motif_cells=idx_motif_cells(I);
motif_idx=motif_idx(I);
Motif_ReCreation_CallBack(hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I2(I));
