function Interaction_heatmap_Callback( source,~,sizes,handles,clusteri )

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

