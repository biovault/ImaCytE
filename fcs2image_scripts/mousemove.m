function mousemove(src,~)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global heatmap_selection

f=src;
obj=hittest(f);
transaparency=0.7;
if isequal(obj.Tag,'h_hd')
    a=get(obj,'parent');
    point=get(a,'currentpoint');
    point2=round([point(1,1) point(1,2)]);   
    if ~point2(1)
        point2(1)=1;
    end
    w=get(obj,'CData');
    if point2(1)>size(w,2)
        point2(1)=size(w,2);
    end
    if point2(2)>size(w,1)
        point2(2)=size(w,1);
    end
    bwmask=ones(size(w,1),size(w,2))*transaparency;
    bwmask(:,[heatmap_selection point2(1,1)])=1;
    bwmask(point2(1,2),:)=1;
    set(obj,'AlphaData',bwmask);
elseif isequal(obj.Tag,'uipanel4')
    a=findobj('Tag','h_hd');
    try 
        w=get(a,'CData'); 
        bwmask=ones(size(w,1),size(w,2))*transaparency;
        if  isempty(heatmap_selection)
            bwmask=1;
        else
            bwmask(:,heatmap_selection)=1;
        end
        set(a,'Alphadata',bwmask);
    catch 
    end
end
