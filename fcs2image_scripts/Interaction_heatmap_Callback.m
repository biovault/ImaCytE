function Interaction_heatmap_Callback( source,~,sizes,handles,clusteri )

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
switch source.Value
    case 1 
        range=sum(cooc(:,1:end-1),2);
        new_cooc=bsxfun(@rdivide,cooc(:,1:end-1),range(:));
        Interaction_heatmap(f,new_cooc',sizes,handles,clusteri);

    case 2
        range=sum(cooc(:,1:end-1));
        new_cooc=bsxfun(@rdivide,cooc(:,1:end-1)',range(:));
        Interaction_heatmap(f,new_cooc,sizes,handles,clusteri);
    case 3 
        cooc=cooc(:,1:end-1);
        cooc2=cooc;
        for i=1:length(cooc); cooc2(i,i)=0; end
        range=sum(cooc2,2);
        new_cooc=bsxfun(@rdivide,cooc,range(:));
        Interaction_heatmap(f,new_cooc',sizes,handles,clusteri);
end



end

