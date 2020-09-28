function [foil_idx] = get_foil_indices(params,trl_idx)
%%
stim_pool = params.stim_mat.ID;

pidx = regexp(stim_pool,'p_');
fidx = regexp(stim_pool,'f_');

ix1 = zeros(length(pidx),1);
ix2 = zeros(length(pidx),1);
for it = 1:length(pidx)
    ix1(it,:)=[~isempty([pidx{it,1}])];
end;

for it = 1:length(fidx)
    ix2(it,:)=[~isempty([pidx{it,1}])];
end;
%% get the categories of the targets
t_cat = [ix1(params.stim_mat.seq(2:3,trl_idx),:)];
t_cat(t_cat==0) =2;
%%
[foils] = params.stim_mat.seq(2:3,:);
[chck] = zeros(2,size(foils,2));%changed 06/07/16
for kt = 1:size(foils,2)
    % this searches for all the triplets that do not match the current
    % triplet
    chck(:,kt) = sort(foils(:,kt)) == sort(params.stim_mat.seq(2:3,trl_idx));%changed 06/07/16
end;

a = find(sum(chck,1)>1);%changed 06/07/16
sel_idx = find(sum(chck,1)==0);

if any(sum(chck(:,sel_idx),1)>0)
    error('wrong index assignment');
end;
%%
[sel_idx] = sel_idx(find(sum(ismember(foils(:,sel_idx),foils(:,a)),1)==0));
if ~isempty(find(sum(ismember(foils(:,sel_idx),foils(:,a)),1)>0))
    error('foil assignments must be different');
end;
%% history check: foils must be either 15 stimuli in the past or the future
n = length(sel_idx);
I = [1:params.trl_idx(1)-15 params.trl_idx(end)+15:n];
sel_idx = sel_idx(find(ismember(sel_idx,I)));
%%
[sel_idx] = sel_idx(randperm(length(sel_idx)));%randomize the order

x = foils(:,sel_idx(1));% get the first one
    
k = 0;
idx = [];
for kt = 2:length(sel_idx)
    
    x2 = foils(:,sel_idx(kt));
    if ~any(ismember(x,x2))
        x = [x x2];
        k = k+1;
        idx(k) = kt;
    end;
    
end;
idx = [1 idx];
foil_idx = sel_idx(idx);
%%
x = ix1(params.stim_mat.seq(2:3,foil_idx));
x(x==0)=2;
x =x';
%% find the complementary foil pairs
c_cat = [setdiff(1:2,t_cat(1)) setdiff(1:2,t_cat(2))];

c = randperm(2);%flip a coin
c = c(1);

sel_idx = {};
sel_idx{c} = find(x(:,c)==c_cat(1));
sel_idx{setdiff(1:2,c)} = find(x(:,setdiff(1:2,c)) ==c_cat(2));

sel_idx{c} = sel_idx{c}(randperm(length(sel_idx{c})));
sel_idx{c} = sel_idx{c}(1);

sel_idx{setdiff(1:2,c)} = sel_idx{setdiff(1:2,c)}(randperm(length(sel_idx{setdiff(1:2,c)})));
sel_idx{setdiff(1:2,c)} = sel_idx{setdiff(1:2,c)}(1);
%% sanity check
foil_idx = [foil_idx(sel_idx{1}) foil_idx(sel_idx{2})];

c_cat2 = [];
c_cat2(c) = [x(sel_idx{c},c)];
c_cat2(setdiff(1:2,c)) = [x(sel_idx{setdiff(1:2,c)},setdiff(1:2,c))];

%PTBdebug;
if any((sort(c_cat) == sort(c_cat2))==0)
    error('Foils must be balanced');
end;
return;