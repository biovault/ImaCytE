function handles = cell2clust(handles)

%   Function that saves the clustering from the cell structure
%   - handles: variable with all the handlers and saved variables of the
%   environment

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global cell4

point2cluster=horzcat(cell4(:).clusters);
for cN = 1:max(point2cluster)
        myMembers = find(point2cluster == cN);
        clustMembsCell{cN} = myMembers;
end

setappdata(handles.figure1,'clustMembsCell',clustMembsCell);
