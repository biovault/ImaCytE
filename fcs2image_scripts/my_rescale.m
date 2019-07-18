function n = my_rescale(simple,dim,range_min,range_max)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

% There is also the built-in function rescale for >2017b
if nargin <3
    range_max=1;
    range_min=0;
end
switch dim
    case 'column'
         n=range_min + ((simple-min(simple))./(max(simple)-min(simple))).*(range_max-range_min);
    case 'columns'
         n=range_min + ((simple-min(simple))./(max(simple)-min(simple))).*(range_max-range_min);
    case 'row'
         n=range_min +((simple-min(simple')')./(max(simple')'-min(simple')')).*(range_max-range_min);
    case 'rows'
         n=range_min +((simple-min(simple')')./(max(simple')'-min(simple')')).*(range_max-range_min);
end
 n(isnan(n))=0;

end

