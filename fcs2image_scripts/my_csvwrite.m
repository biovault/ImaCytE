function    my_csvwrite(filename,numeric_array,headers,flag)

% It writes the cell meta-data into an fcs file
%   - filename: a string with the file name
%   - numeric_array: a matrix where each row is the meta-data of a cell and
%   each column a feature
%   -headers: the names of the features on the numeric_array

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

if nargin <4
    flag=0;
end

    fid = fopen(filename,'W');
    if ~isempty(headers)
        for i=1:length(headers)
            fprintf(fid,'%s,',headers{i});
        end
        fprintf(fid,'\n');
    end
    
    for i=1:size(numeric_array,1)
        temp=size(numeric_array,2);
        if flag
            temp=nnz(numeric_array(i,:));
        end
        for j=1:temp
            fprintf(fid,'%g,',numeric_array(i,j));        
        end
        fprintf(fid,'\n');
    end
    fclose(fid);
end
