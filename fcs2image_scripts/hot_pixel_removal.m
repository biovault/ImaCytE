function I_new=hot_pixel_removal(I,prc)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

filter_size=[5 5];
p2=prctile(I(:), prc);
maskk=I>p2;
masked_val=maskk.*I;
dilmask=imdilate(maskk,[ ones(1,5) ;ones(1,5); zeros(1,5);ones(1,5);ones(1,5)]);
maskk_extend=dilmask | maskk;
extended_val=I.*maskk_extend;
median_val2=medfilt2(extended_val,filter_size,'symmetric');
% median_val2 = filter2(fspecial('average',5),extended_val);
median_val2=median_val2.*maskk;
values_that_change=masked_val>(median_val2.*4);
values_that_change=values_that_change.*median_val2;
I_new=I-masked_val+values_that_change;
end