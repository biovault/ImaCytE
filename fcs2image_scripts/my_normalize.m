function n = my_normalize(fin_mat,dim)
% There is also the built-in function normalize for >2018a 

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox
fin_mat(isnan(fin_mat))=0;

switch dim
    case 'column'
         n=(fin_mat-mean(fin_mat))./std(fin_mat);
    case 'columns'
         n=(fin_mat-mean(fin_mat))./std(fin_mat);
    case 'row'
         n=(fin_mat-mean(fin_mat')')./std(fin_mat')';
    case 'rows'
         n=(fin_mat-mean(fin_mat')')./std(fin_mat')';
end
 n(isnan(n))=0;
 
end

