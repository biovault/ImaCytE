function dropObject_colocalization(hObject,eventdata,handles)
global dragging
global dropped2
global dropped3
global generic_dropped
% cluster_of_i=getappdata(handles.figure1,'cell_of_interest');
% cluster_of_micro=getappdata(handles.figure1,'cell_of_micro');

        if ~isempty(dragging)  && isvalid(dragging)
            cc = get(gcf,'CurrentPoint');
            if ( cc(2)>=0.7 && cc(1)<1 && cc(1)>0.5 && cc(2)<1)
                if  cc(2)<=0.85
                    dropped3=[dropped3 generic_dropped];
                    dropped3=unique(dropped3,'stable');
                else
                    dropped2=[dropped2 generic_dropped];
                    dropped2=unique(dropped2,'stable');
                end
                z=getappdata(handles.figure1,'z');
                fr=getappdata(handles.figure1,'fr');
                motifs=getappdata(handles.figure1,'motifs');
                idx_motif_cells=getappdata(handles.figure1,'idx_motif_cells');
                motif_idx=getappdata(handles.figure1,'motif_idx');
                hfig=getappdata(handles.figure1,'hfig');
                event.Value=7;
                I=1:size(motifs,1);
                Colocalization_details_environment_creation(handles,dropped2,dropped3);
            end
            delete(dragging);
        end
end


