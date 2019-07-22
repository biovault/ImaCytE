function [tree,leafOrder] = dendro_calculator( fin_mat )
% Calculation of the hierarchical clustetring 
%   - fin_mat: a matrix where each row represents a median high-dimensional vector for each cluster 

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

D = pdist(fin_mat');
tree = linkage(fin_mat','single');
leafOrder = optimalleaforder(tree,D);

