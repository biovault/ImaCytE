function Motif_Threshold_Callback(source,~,hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I2)

% Callback function that according to the selected threshold it loads a subset of motifs
%   - source: used as identifiers in order to understand what kind of
%   selection/reordering should be arranged
%   - hfig: identifier of the figure object whehre the motif will be created
%   - handles: variable with all the handlers and saved variables of the
%   environment
%   - z : vector with the z-score value of each motif
%   - fr: vector with the relative frequency regarding the cluster of a cell for each motif
%   - motifs: a matrix which shows the clusters of the microenvironment that each motif represents
%   - idx_motfi: a cell array that saves the idxes of the cells that
%   are grouped under each motif.
%   -motif_idx: a vector for the cluster of the cells of each motif
%   - I2: vector representing the idx of motifs that should be selected

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
