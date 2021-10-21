function cohort_idx=idx_2_cohort_idx(idxs)

global cell4
cohort_idx=[];
if isempty(idxs)
    return;
end

num_cohorts=max([cell4(:).cohort]);
for i=1:num_cohorts
    temp=find([cell4(:).cohort]==i);
    temp=find(ismember(temp,idxs));
    temp=[temp' ones(numel(temp),1).*i];
    cohort_idx=[cohort_idx ; temp];
end
