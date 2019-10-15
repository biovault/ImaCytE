function Show_Heatmap_Selection(selection)

% Highlights the selected cluster from the heatmap
%   -selection: scalar representing the selected cluster

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

    transparency=0.7;
    a=findobj('Tag','h_hd');
    a=a(end);
    w=get(a,'CData');
    if  isempty(selection)
        bwmask=1;
    else
        bwmask=ones(size(w,1),size(w,2))*transparency;
        bwmask(:,selection)=1;
    end
    set(a,'AlphaData',bwmask);
end

