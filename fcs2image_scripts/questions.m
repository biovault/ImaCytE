function flags = questions

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

answer1 = questdlg('Would you like to binarize your data?', ...
	'Outlier Removal', ...
	'Yes','No thank you','No thank you');
% answer1='No thank you';
% Handle response
switch answer1
    case 'Yes'
        flags(1)=1;
        answer = questdlg('What type of thresholding do you want?', ...
            'Threshold types', ...
            'Threshold values','Threshold segmentation','No');
        switch answer
            case 'Threshold values'
                flags(2)=1;
            case 'Threshold segmentation'
                flags(2)=0;
        end
    case 'No thank you'
        flags(1)=0;
        answer2 = questdlg('Would you like an outlier removal function to be applied in the data?', ...
            'Outlier Removal', ...
            'Yes','No thank you','No thank you');
        % Handle response
        switch answer2
            case 'Yes'
                flags(2)=1;
            case 'No thank you'
                flags(2)=0;
        end

%         answer3 = questdlg('Would you like comabt to transform your data?', ...
%             'Batch-effect Removal', ...
%             'Yes','No thank you');
%         % Handle response
%         switch answer3
%             case 'Yes'
%                 flags(3)=1;
%             case 'No thank you'
%                 flags(3)=0;
%         end
end



end

