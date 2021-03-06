function [stim_mat] = organize_stim_mat(concept_neurons,ID)
%%
stim_mat.ID = ID.id;
stim_mat.idx =ID.idx;
%%
pidx = concept_neurons;
c_id = zeros(size([concept_neurons{:}]));

for it = 1:length(concept_neurons)
    c_id(it,:) = it*ones(1,length(concept_neurons{it}));
end;
c_idx = sort(c_id(:));
n = length(unique(c_idx)); 
n =n*(n-1)/2;

a = ([pidx{:}]); a = a(:);
pidx = a;
p = stim_mat.idx(pidx,:); p = p(:); p=sort(p);
n= n*(length(unique(pidx)));

lkp = [c_idx p];
%%
p = reshape(p,[length(p)/length(concept_neurons) length(concept_neurons)])';
%%
c=0;
x1 = zeros(n,2);
for it = 1:size(p,1)-1
    for jt = 1:size(p,2)
        
        for mt = it+1:size(p,1)
            for kt = 1:size(p,2)                                
                c =c+1;
                x1(c,:) = [p(it,jt) p(mt,kt)];
            end;
        end;
        
    end;
end;
%%
p = x1;
if length(p) ~=n
    error('sequence length must be multiple of n');
end;
%%
c_idx = unique(c_idx);
n = length(unique(c_idx)); 
n =n*(n-1)/2;
c=0;
x2 = zeros(n,2);
for it = 1:size(c_idx,1)-1
    for jt = 1:size(c_idx,2)
        
        for mt = it+1:size(c_idx,1)
            for kt = 1:size(c_idx,2)                                
                c =c+1;
                x2(c,:) = [c_idx(it,jt) c_idx(mt,kt)];
            end;
        end;
        
    end;
end;
tc = x2;
%%
cidx = setdiff(1:size(stim_mat.ID,1),pidx);
cidx = cidx(randperm(length(cidx)));
c = cidx;

c = c(1:size(p,1));

if size(p,1) ~= length(c)
    error('number of pairs and cues must match');
end;

if length(find(ismember(c,p))) ~=0
    error('overlap between pair and cue indices');
end;
%%
seq = zeros(length(c)*3,1);
idx = 1:3;
for it = 1:length(c)
    fc = randperm(2);
    seq(idx) = [c(it) p(it,fc)];
    idx = idx+3;
end;

seq = reshape(seq,[3 length(seq)/3]);
for k = 1:100
    seq = seq(:,randperm(size(seq,2)));
end;
%%
b = [];for it = 1:length(concept_neurons);b(1,find(ismember(seq(2,:),concept_neurons{it}))) = it;b(2,find(ismember(seq(3,:),concept_neurons{it}))) = it;end;
%%
if length(unique(seq(1,:))) ~= length(unique(c));
    error('wrong index assignement');
end;
%%
stim_mat.tc = tc;
stim_mat.lkp = lkp;
stim_mat.c = c;
stim_mat.p = p;
stim_mat.seq = seq;
stim_mat.xc =b;
if any(ismember(stim_mat.c,stim_mat.p))
    error('overlap between pair and cue indices');
end;
%%
return;