function [foil_idx] = get_foil_indices2(trl_idx)
% if encoding idx is: [1 2 3 4 5]
% retrieval idx is the encoding idx permutated: trl_idx = [4 5 2 1 3]
% foil_idx is a permutation in which no number equals trl_idx
%%
f = 0;
while f == 0
    d =[];
    sel_idx = cell(length(trl_idx),1);
    for jt = randperm(length(trl_idx))
        
        
        ix = setdiff(1:length(trl_idx),[jt d]); % all trial indices without the trials in jt and d. d are trials from previous jt iterations.
        ix = ix(randperm(length(ix))); % shuffle ix
        if ~isempty(ix)
            ix = ix(length(ix)); % make ix the last value in ix
        else
            ix = jt;
        end
        
        
        d = [d ix];
        sel_idx{jt} = trl_idx(ix);
    end
    foil_idx = [sel_idx{:}];
    
    if any(diff([trl_idx;foil_idx],[],1)==0) ~=1
        f =1;
    end
end
%%
if any(diff([trl_idx;foil_idx],[],1)==0);error('foils and targets cannot overalp');end
%%
return;