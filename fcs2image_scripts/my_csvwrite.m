function    my_csvwrite(filename,numeric_array,headers)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


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

