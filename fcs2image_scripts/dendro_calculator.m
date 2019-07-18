function [tree,leafOrder] = dendro_calculator( fin_mat )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox
D = pdist(fin_mat');
tree = linkage(fin_mat','single');
leafOrder = optimalleaforder(tree,D);

