function n = my_rescale(simple,dim,range_min,range_max)

% Min/Max normalization
% There is also the built-in function rescale for >2017b
%   - fin_mat: the data matrix
%   - dim: the dimension based on which you want to perform the
%   normalization

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

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

