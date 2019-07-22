function    my_csvwrite(filename,numeric_array,headers)

% It writes the cell meta-data into an fcs file
%   - filename: a string with the file name
%   - numeric_array: a matrix where each row is the meta-data of a cell and
%   each column a feature
%   -headers: the names of the features on the numeric_array

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

    fid = fopen(filename,'W');
    for i=1:length(headers)
        fprintf(fid,'%s,',headers{i});
    end
    fprintf(fid,'\n');

    for i=1:size(numeric_array,1)
        for j=1:size(numeric_array,2)
            fprintf(fid,'%g,',numeric_array(i,j));        
        end
        fprintf(fid,'\n');
    end
    fclose(fid);
end

