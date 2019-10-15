function Interaction_heatmap_Callback( source,~,handles )

% Callback upon selection of the normalization type of the interaction heatmap
%   - source: inherited from the varaible that is selected from the user,
%   either "Normalization by row", "Normalization by column", "Normalization excluding diagonal"
%   - sizes: The number of cells that each cluster has
%   - handles: variable with all the handlers and saved variables of the
%   environment
%   - clusteri: matrix wehre each row represent the cell ids of the cells that exist
%   in their neihgborhood

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

cooc=getappdata(handles.figure1,'cooc_overall');
f=handles.uipanel1;

h_i=get(f,'Children');
h_i=get(h_i(6),'Children');

switch source.Value
    case 1 
        new_cooc=cooc./sum(cooc);
    case 2
        new_cooc=cooc./sum(cooc,2);
    case 3
        new_cooc=cooc - diag(diag(cooc));
        new_cooc=cooc./sum(new_cooc);
    case 4
        new_cooc=cooc;
end

set(h_i(end),'CData',new_cooc)
set(handles.figure1,'windowbuttonmotionfcn',{@mousemove_interaction,handles});


end

