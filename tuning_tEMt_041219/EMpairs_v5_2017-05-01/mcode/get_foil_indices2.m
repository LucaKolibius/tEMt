function [foil_idx] = get_foil_indices2(trl_idx)

%%
f = 0;
while f == 0
    d =[];
    sel_idx = cell(length(trl_idx),1);
    for jt = randperm(length(trl_idx))
        
        
        ix = setdiff(1:length(trl_idx),[jt d]);
        ix = ix(randperm(length(ix)));
        if ~isempty(ix)
            ix = ix(length(ix));
        else
            ix = jt;
        end;
        
        
        d = [d ix];
        sel_idx{jt} = trl_idx(ix);
    end;
    foil_idx = [sel_idx{:}];
    
    if any(diff([trl_idx;foil_idx],[],1)==0) ~=1
        f =1;
    end;
end;
%%
if any(diff([trl_idx;foil_idx],[],1)==0);error('foils and targets cannot overalp');end;
%%
return;