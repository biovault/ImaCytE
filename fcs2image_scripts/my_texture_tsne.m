function embed_mat= my_texture_tsne(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% load('L:\Scratch\Baldur\temptextsne\mnist-original.mat');

%%

npdt = mat2np(data);
texTsne = py.nptsne.TextureTsne();
% Extract 
embed = texTsne.fit_transform(py.numpy.array(npdt));
%embed_sh = double(py.array.array('d', embed.shape));
embed_mat = double(py.array.array('d', py.numpy.nditer(embed)));

embed_mat = reshape(embed_mat, 2,[]);

% tsne_map=fast_atsne_texture(my_normalize(double(data),'column'));
embed_mat=embed_mat';
% figure; scatter(embed_mat(1,:), embed_mat(2,:), [], label);
% figure; gscatter(tsne_map(:,1),tsne_map(:,2),label');

%%
function npary = mat2np(mat)

% convert matlab matrix to python (Numpy) ndarray 
sh = fliplr(size(mat));
mat2 = reshape(mat,1,numel(mat));
npary = py.numpy.array(mat2);
npary = npary.reshape(int32(sh)).transpose();





