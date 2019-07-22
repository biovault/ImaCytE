function Motif_Selection_Callback(source,event,hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I2)

% Callback function that arranges which motifs should be loaded and their
% order
%   - source,event: used as identifiers in order to understand what kind of
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

   val = source.Value; 
    switch val
        case 1  %Default case
            z=getappdata(handles.figure1,'z');
            fr=getappdata(handles.figure1,'fr');
            motifs=getappdata(handles.figure1,'motifs');
            idx_motif_cells=getappdata(handles.figure1,'idx_motif_cells');
            motif_idx=getappdata(handles.figure1,'motif_idx');
            hfig=getappdata(handles.figure1,'hfig');
            I=1:size(motifs,1);
            I2=1:size(motifs,1);
        case 2 % Ascending reordering according to Z value
            [z,I]=sort(z);
            fr=fr(I);
            motifs=motifs(I,:);
            idx_motif_cells=idx_motif_cells(I);
            motif_idx=motif_idx(I);
        case 3 % Descending reordering according to Z value
            [z,I]=sort(z,'descend');
            fr=fr(I);
            motifs=motifs(I,:);
            idx_motif_cells=idx_motif_cells(I);
            motif_idx=motif_idx(I);
        case 4 % Ascending reordering according to frequency of the motif
            [fr,I]=sort(fr);
            z=z(I);
            motifs=motifs(I,:);
            idx_motif_cells=idx_motif_cells(I);
            motif_idx=motif_idx(I);
        case 5 % Descending reordering according to frequency of the motif
            [fr,I]=sort(fr,'descend');
            z=z(I);
            motifs=motifs(I,:);
            idx_motif_cells=idx_motif_cells(I);
            motif_idx=motif_idx(I);
        case 6 % Selection of the motifs with specific cluster in the center and specific clusters in the microenvironment
            checked_rows=1:size(motifs,1);
            counter=1;
            if ~isempty(event)
                for i=event
                    if counter ==1
                        checked_rows=checked_rows(motif_idx == i)';
                    else
                        checked_rows=[checked_rows; find(motif_idx == i)];
                    end
                    counter=counter+1;
                end
            else
                checked_rows=[];
            end
            I=unique(checked_rows);
            fr=fr(I);
            z=z(I);
            motifs=motifs(I,:);
            idx_motif_cells=idx_motif_cells(I);
            motif_idx=motif_idx(I);
        case 7 % Selection of all the motifs with specific cluster in the center 
            checked_rows=1:size(motifs,1);
            checked_rows2=[];
            if ~isempty(event)
                for i=1:size(event,1)
                    temp=checked_rows(motif_idx == event(i,1))';
                    temp=temp(motifs(temp,event(i,2))==1);
                    checked_rows2=[checked_rows2 ;temp];
                end
            end
            I=unique(checked_rows2);
            fr=fr(I);
            z=z(I);
            motifs=motifs(I,:);
            idx_motif_cells=idx_motif_cells(I);
            motif_idx=motif_idx(I);
    end
    
    Motif_ReCreation_CallBack(hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I2(I));
