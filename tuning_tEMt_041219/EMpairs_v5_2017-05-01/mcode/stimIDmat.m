function [ID,idx] = stimIDmat(Imf)
%%
id = cell(length(Imf),1);
idx = zeros(length(Imf),1);
for it = 1:length(Imf)
    id{it} = Imf(it).name(1:regexp(Imf(it).name,'\d')-1);
    idx(it) = it;
end;
%%
ID.id = id;
ID.idx = idx;

return;