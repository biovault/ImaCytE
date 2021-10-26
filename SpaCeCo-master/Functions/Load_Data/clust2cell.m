function clust2cell(handles)

%   Function that saves the clustering also to cell structure
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

    global cell4;
    clustMembsCell=getappdata(handles.figure1, 'clustMembsCell');

    for i=1:length(clustMembsCell)
        point2cluster(clustMembsCell{i})=i;
    end

    next_idx(1)=1;
    next_idx(2)=0;
    for i=1:length(cell4)
        next_idx(2)=next_idx(2)+length(cell4(i).idx);
        cell4(i).clusters=point2cluster(next_idx(1):next_idx(2));
        next_idx(1)=next_idx(2)+1;
    end

end

