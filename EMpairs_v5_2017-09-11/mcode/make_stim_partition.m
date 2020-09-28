function [p] = make_stim_partition(nImages,nStims)    
%%
if nargin == 0
    nImages = 56;
    nStims = 3;
end;
%%
npartitions = floor(nImages/nStims);
[rd_idx] = randperm(nImages);
%%
p = zeros(npartitions,nStims);
for it = 1:npartitions
    p(it,:) = rd_idx(1:3);
    rd_idx(1:3) = [];
end;
%%
return;