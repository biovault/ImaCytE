function cohort_idx=cohort_idx_2_idx(idxs)

global cell4
if isempty(idxs)
    cohort_idx=[];
    return
end
cohort_idx=[];
num_cohorts=max([cell4(:).cohort]);
for i=1:num_cohorts
    temp=idxs(idxs(:,2)==i,1);
    temp2=find([cell4(:).cohort]==i)';
    cohort_idx=[cohort_idx ;temp2(temp)];
end
