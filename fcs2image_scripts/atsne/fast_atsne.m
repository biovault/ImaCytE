function [mappedX,indexmatrix,pmatrix] = fast_atsne(X, no_dims, perplexity, theta, nriters)
%FAST_TSNE Runs the C++ implementation of Barnes-Ht
%   mappedX = fast_tsne(X, no_dims, initial_dims, perplexity, theta, random_seed, init_Y, save_interval)
%
% Runs the C++ implementation of Barnes-Hut-SNE. The high-dimensional 
% datapoints are specified in the N x D matrix X. The dimensionality of the 
% datapoints is reduced to initial_dims dimensions using PCA (default = 50)
% before t-SNE is performed. Next, t-SNE reduces the points to no_dims
% dimensions. The perplexity of the input similarities may be specified
% through the perplexity variable (default = 30). The variable theta sets
% the trade-off parameter between speed and accuracy: theta = 0 corresponds
% to standard, slow t-SNE, while theta = 1 makes very crude approximations.
% Appropriate values for theta are between 0.1 and 0.7 (default = 0.5).
% The function returns the two-dimensional data points in mappedX. The
% parameter random_seed can be used to set the random seed for this run
% (default = 0). The variable init_Y can be used to specify an initial map;
% the input matrix should have size N x no_dims. The variable save_interval
% can used to set the number of iterations between two intermediate saves
% of the map during learning (default = [], which means no intermediate
% saving is performed).
%
%
% NOTE: The function is designed to run on large (N > 5000) data sets. It
% may give poor performance on very small data sets (it is better to use a
% standard t-SNE implementation on such data).


% Copyright (c) 2014, Laurens van der Maaten (Delft University of Technology)
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright
%    notice, this list of conditions and the following disclaimer in the
%    documentation and/or other materials provided with the distribution.
% 3. All advertising materials mentioning features or use of this software
%    must display the following acknowledgement:
%    This product includes software developed by the Delft University of Technology.
% 4. Neither the name of the Delft University of Technology nor the names of 
%    its contributors may be used to endorse or promote products derived from 
%    this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY LAURENS VAN DER MAATEN ''AS IS'' AND ANY EXPRESS
% OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
% OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO 
% EVENT SHALL LAURENS VAN DER MAATEN BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
% IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
% OF SUCH DAMAGE.

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

atSNEinputfile='data5.bin';
% pmatrixfilename='pmatrix.out';
tSNEcommand='atsne_cmd ';
outputfilename='outputdata.bin';
loadpmatrix=0;
[curr_path, ~, ~] = fileparts(mfilename('fullpath'));
curr_path = [curr_path filesep];
tSNEcommand=[curr_path tSNEcommand];
% cd(curr_path);

%     if nargin < 2
%         error('Function should have at least two inputs.');
%     end
    if ~exist('initial_dims', 'var') || isempty(no_dims)
        no_dims = 2;
    end
    if ~exist('perplexity', 'var') || isempty(perplexity)
        perplexity = 30;
    end
    if ~exist('theta', 'var') || isempty(theta)
        theta = 0.85;
    end
    if ~exist('nriters', 'var') || isempty(nriters)
        nriters = 1000;
    end

    
    numexagerationiters=min([[nriters/3 300]]);
    
%     oldpath=cd(atSNEexecutablepath);
    transposed_data = X';
    fileID  = fopen(atSNEinputfile,'w');
    fwrite(fileID,transposed_data,'float');
    fclose(fileID);
    
    ndatapoints=size(X,1);
    nhighdims=size(X,2);
    arguments=cell(1);
%     cd(curr_path);
    arguments{1}=[tSNEcommand atSNEinputfile ' ' outputfilename ' ' num2str(ndatapoints) ' ' ...
        num2str(nhighdims) ' -i ' num2str(nriters) ' -d ' num2str(no_dims) ...
        ' -p ' num2str(perplexity) ' -x ' num2str(numexagerationiters) ' -s pmatrix.out' ' -t ' num2str(theta)];
  
    tic, system(arguments{1}); toc
    delete(atSNEinputfile);
   
    h = fopen(outputfilename, 'rb');
	mappedX = fread(h, [no_dims ndatapoints],'float');
	fclose(h);
    
    if(loadpmatrix)
    h=fopen(pmatrixfilename,'rb');
    nrows=fread(h,1,'int');
    for i=1:nrows
        ncols=fread(h,1,'int');
        for j=1:ncols
            indexmatrix(i,j)=fread(h,1,'int');
            pmatrix(i,j)=fread(h,1,'float');
        end
    end
    fclose(h);
    delete(pmatrixfilename);
    indexmatrix=indexmatrix+1;
    [pmatrix,I]=sort(pmatrix,2,'descend');
    temp=indexmatrix;

    for i=1:nrows
        temp(i,:)=indexmatrix(i,I(i,:));
    end
    indexmatrix=temp;
    else
        indexmatrix=0;
        pmatrix=0;
    end
    
    mappedX= mappedX';
%     cd(curr_path);
end



