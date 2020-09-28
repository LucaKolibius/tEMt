function [stim_mat] = organize_stim_mat_concept_neurons(concept_neurons,ID)
%%
% %%
sel_idx1 = [concept_neurons{:}];
sel_idx1 = sort(sel_idx1(:));

sel_idx2 = setdiff(1:length(ID.id),sel_idx1);
sel_idx2 = sel_idx2(randperm(length(sel_idx2)));
%%
[c] = generate_concept_neuron_pairs( sel_idx1 );
%[c] = generate_unique_concept_neuron_pairs( concept_neurons );
c(find(diff(c,[],2)==0),:)=[];
c = c(randperm(size(c,1)),:);
%%
n(1) = size(c,1);
n(2) = length(sel_idx2);

seq = zeros(3,min(n));
for it = 1:min(n)
    seq(1,it) = sel_idx2(it);
    fc = randperm(2);
    seq(2:3,it) = c(it,fc)';
end;
%%
tc = zeros(size(seq(2:3,:)));
for it = 1:length(concept_neurons)
    idx = find(ismember(seq(2:3,:),concept_neurons{it}));
    tc(idx) = it;
end;
%%
stim_mat.ID = ID.id;
stim_mat.idx =ID.idx;
stim_mat.tc = sum(tc.^2,1);
stim_mat.lkp = c;
stim_mat.c = sel_idx2;
stim_mat.p = sel_idx1;
stim_mat.seq = seq;
stim_mat.xc =[];