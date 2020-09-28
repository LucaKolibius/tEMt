function ID = stimIDmat(Imf)
%%
id = cell(length(Imf),1);
idx = zeros(length(Imf),1);
for it = 1:length(Imf)
    id{it} = Imf(it).name(1:regexp(Imf(it).name,'\d')-1);
%     id{it} = Imf(it).name(1:regexp(Imf(it).name,'.bmp')-1);

    idx(it) = it;
end

%% if it is an odd number of stimuli, delete the last one
if mod(size(id,1),2) == 1
    id(end) = [];
    idx(end) = [];
end

ID.id = id;
ID.idx = idx;

return;