function [stim_mat] = organize_stim_mat2(concept_neurons,ID)
%%
stim_mat.ID = ID.id;
stim_mat.idx =ID.idx;
%%
pidx = concept_neurons;
n = zeros(length(pidx),1);
for it =1:length(pidx)
    n(it) = length(pidx{it});%get the number of images
end;

m = find(n == min(n));% find smallest number
idx = setdiff(1:length(n),m);% search for larger vectors

for it = 1:length(idx)%loop over larger vectors

    pidx{idx(it)} = pidx{idx(it)}(randperm(length(pidx{idx(it)})));%randomize
    pidx{idx(it)} = pidx{idx(it)}(1:min(n));%keep smaller number
    
    concept_neurons{idx(it)} = concept_neurons{idx(it)}(1:min(n));%adjust for indices

end;
%%
c_id = zeros(size(concept_neurons,1),min(n));%preallocate

for it = 1:length(concept_neurons)
    c_id(it,:) = it*ones(1,length(concept_neurons{it}));% assign id to each element
end;
%%
c_idx = sort(c_id(:));% vector with element codes
n = length(unique(c_idx)); 
n =n*(n-1)/2;% number of pairwise comps

a = ([pidx{:}]); a = a(:);% indices of each element
pidx = a;
p = stim_mat.idx(pidx,:); p = p(:); p=sort(p);
n= n*(length(unique(pidx)));

lkp = [c_idx p];
%%
p = reshape(p,[length(p)/length(concept_neurons) length(concept_neurons)])';
%%
[comb] = generate_pair_combinations(p);

o = zeros(size(comb,1),1);

for it = 1:size(comb,1)
    
    o(it) = strcmp(ID.id{comb(it,1)}(1),ID.id{comb(it,2)}(1));
    
end;
sel_ix = find(o==1);

k=0;sel1 =[];
ix = regexp(ID.id(comb(sel_ix,:)),'f_');
for it = 1:length(ix);
   if ~isempty(ix{it})
       k=k+1;
       sel1(k) =it;
   end;
end;
sel1 = sel_ix(sel1);

k=0;sel2 =[];
ix = regexp(ID.id(comb(sel_ix,:)),'p_');
for it = 1:length(ix);
   if ~isempty(ix{it})
       k=k+1;
       sel2(k) =it;
   end;
end;
sel2 = sel_ix(sel2);

sel3 = find(o==0);

sel1 = sel1(randperm(length(sel1)));
sel2 = sel2(randperm(length(sel2)));
sel3 = sel3(randperm(length(sel3)));

sel1 = sel1(1:25);
sel2 = sel2(1:25);
sel3 = sel3(1:50);
%%
p = comb([sel1;sel2;sel3],:);
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

sel = [];k = 0;
for jt = 1:length(concept_neurons)
    ref = ID.id{concept_neurons{jt}};
    ix = regexp(ID.id(cidx),ref(1:2));
    for lt = 1:length(ix)
        if ~isempty(ix{lt})
            k = k+1;
            sel(k) = lt;
        end;
    end;
end;
cidx(sel) = [];
c = cidx;

c = c(1:length(p));

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