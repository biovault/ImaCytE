function Motif_Selection_Callback(source,event,hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I2)
%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

   val = source.Value; 
    switch val
        case 1
            z=getappdata(handles.figure1,'z');
            fr=getappdata(handles.figure1,'fr');
            motifs=getappdata(handles.figure1,'motifs');
            idx_motif_cells=getappdata(handles.figure1,'idx_motif_cells');
            motif_idx=getappdata(handles.figure1,'motif_idx');
            hfig=getappdata(handles.figure1,'hfig');
            I=1:size(motifs,1);
            I2=1:size(motifs,1);
        case 2
            [z,I]=sort(z);
            fr=fr(I);
            motifs=motifs(I,:);
            idx_motif_cells=idx_motif_cells(I);
            motif_idx=motif_idx(I);
        case 3
            [z,I]=sort(z,'descend');
            fr=fr(I);
            motifs=motifs(I,:);
            idx_motif_cells=idx_motif_cells(I);
            motif_idx=motif_idx(I);
        case 4
            [fr,I]=sort(fr);
            z=z(I);
            motifs=motifs(I,:);
            idx_motif_cells=idx_motif_cells(I);
            motif_idx=motif_idx(I);
        case 5
            [fr,I]=sort(fr,'descend');
            z=z(I);
            motifs=motifs(I,:);
            idx_motif_cells=idx_motif_cells(I);
            motif_idx=motif_idx(I);
        case 6
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
        case 7 
            checked_rows=1:size(motifs,1);
            checked_rows2=[];
            if ~isempty(event)
                for i=1:size(event,1)
                    temp=checked_rows(motif_idx == event(i,1))';
                    temp=temp(motifs(temp,event(i,2))==1);
                    checked_rows2=[checked_rows2 ;temp];
                end
%             else
%                 checked_rows2=checked_rows;
            end
            I=unique(checked_rows2);
            fr=fr(I);
            z=z(I);
            motifs=motifs(I,:);
            idx_motif_cells=idx_motif_cells(I);
            motif_idx=motif_idx(I);
    end
    
    
%     sizes_=cellfun(@(x) length(x),idx_motif_cells,'UniformOutput' ,false);
% sizes_=cell2mat(sizes_);
% checked_rows2= sizes_ >= val;
% I=checked_rows2;
% fr=fr(I);
% z=z(I);
% motifs=motifs(I,:);
% idx_motif_cells=idx_motif_cells(I);
% motif_idx=motif_idx(I);
%     Motif_Creation_CallBack( hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx);
    Motif_ReCreation_CallBack(hfig,handles,z,fr,motifs,idx_motif_cells,motif_idx,I2(I));
