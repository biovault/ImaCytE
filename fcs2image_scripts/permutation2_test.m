function [z_overall,fr_overall,motifs_overall,idx_cells_overall,out_overall,idx_motifs_overall] =permutation2_test(clusteri,cluster,num_clusters)

%   Copyright 2019 Antonios Somarakis (LUMC) ImaCytE toolbox

global val
% prompt={'Number of permutations'};
% dlg_title='Input';
% num_lines=1;
% defaultans={'100'};
% x=inputdlg(prompt,dlg_title,num_lines,defaultans);
% permutations=str2num(x{:}); 
permutations=50;

prompt={'Minimum number of cells grouped under a motif that makes it significant'};
dlg_title='Input';
num_lines=1;
defaultans={'5'};
x=inputdlg(prompt,dlg_title,num_lines,defaultans);
val=str2num(x{:}); 
% val=5;

if nargin<3
    num_clusters=unique(cluster)';
end

z_overall=[];
fr_overall=[];
out_overall=[];
motifs_overall=[];
idx_cells_overall=[];
idx_motifs_overall=[];


Neighbor_Matrix = clusteri;
Neighbor_Matrix_index = Neighbor_Matrix+1;
Phenograph_Vector = cluster;
Phenograph_Vector_index =[0;Phenograph_Vector];

% Replace all neighbors with corresponding cell type
Phenograph_Neighor_Matrix = Phenograph_Vector_index(Neighbor_Matrix_index);

% Calculate all possible interactions
Available_Labels = unique(Phenograph_Vector);


gr2=zeros(length(clusteri),length(Available_Labels));
for i=1:length(clusteri)
    for j=1:size(Neighbor_Matrix_index,2)
        if Phenograph_Neighor_Matrix(i,j) == 0
            continue;
        else
            try
            gr2(i,Phenograph_Neighor_Matrix(i,j))=gr2(i,Phenograph_Neighor_Matrix(i,j))+1;
            catch 
            end
        end
    end
end
gr2_=bi2de(gr2>0);

for k=num_clusters

x=find( Phenograph_Vector == k);
actual_motifs= gr2_( x);
[out_u,~,ic]=unique(actual_motifs);
[N,~,~] = histcounts(ic,'BinMethod','integers');
out=[out_u  N'];
out=out(out(:,2) >val ,1:2);
idx_motifs=find(N >val);
idx_cells=[];
for i=1:length(idx_motifs)
    idx_cells{i}=x(ic == idx_motifs(i));
end

if isempty(out)
    continue;
else
    motifs=de2bi(out(:,1),length(Available_Labels));
end

fr=out(:,2)/length(x);
tempo=out(:,1);
temp_all=cell(1,permutations);
parfor p=1:permutations
    % Generate matrix for permutation
    Phenograph_Vector_perm = Phenograph_Vector(randperm(length(Phenograph_Vector)));
    Phenograph_Vector_index_perm = [0;Phenograph_Vector_perm];
    % Replace all neighbors with corresponding cell type
    Phenograph_Neighor_Matrix_perm = Phenograph_Vector_index_perm(Neighbor_Matrix_index);
    % Run through all combos_all_histcount
    
    neighlist_k=find(Phenograph_Vector_perm ==k);
    gr2=zeros(length(neighlist_k),length(Available_Labels));

    for i=1:length(neighlist_k)
        for j=1:size(Phenograph_Neighor_Matrix_perm,2)
            if Phenograph_Neighor_Matrix_perm(neighlist_k(i),j) == 0
                continue;
            else
                gr2(i,Phenograph_Neighor_Matrix_perm(neighlist_k(i),j))=gr2(i,Phenograph_Neighor_Matrix_perm(neighlist_k(i),j))+1;
            end
        end
    end
    
    gr3_=bi2de(gr2>0);
    
    [out1,~,ic2]=unique(gr3_);
    [N,~,~] = histcounts(ic2,'BinMethod','integers');
    out1=[out1  N'];
      %     out1=tabulate(gr2_);
    [~,ia,ib]=intersect(tempo, out1(:,1));
    temp_all{p}=zeros(length(tempo),1);
    temp_all{p}(ia)=out1(ib,2);
end

out=[out cell2mat(temp_all)];
z=(out(:,2) - mean(out(:,3:end),2))./((std(out(:,3:end),0,2)+1)/sqrt(permutations));  

z_overall=[z_overall ;z];
fr_overall=[fr_overall ; fr];
out_overall=[out_overall ;out];
motifs_overall=[motifs_overall; motifs];
idx_cells_overall=[idx_cells_overall ; idx_cells' ];
idx_motifs_overall=[idx_motifs_overall ; [k*ones(length(z),1)]];
end
