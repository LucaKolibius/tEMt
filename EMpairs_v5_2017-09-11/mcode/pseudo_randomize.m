function [ID,idx] = pseudo_randomize(ID,nreps)

idx = 1:length(ID);

x = cell(length(ID),1);
for it = 1:length(ID)
    x{it} = ID{it}(regexp(ID{it},'_')+1:end);
end;

ID2 = x;

f = 0;
while f <1
    
    x1 = cell(length(ID2)*nreps,1);
    x2 = zeros(length(ID2)*nreps,1);
    
    ix = 1:length(ID2);
    for it = 1:nreps
        x1(ix) = ID2(randperm(length(ID2)));
        x2(ix) = idx(randperm(length(ID2)));
        ix = ix+length(ix);
    end;
    
    chck = zeros(length(x1)-2,1);
    for it = 2:length(x1)-1
        chck(it) = strcmp(x1(it),x1(it+1));
    end;
    
    if sum(chck) <= length(unique(ID2))
        f =1;
    end;
    
end;
ID = ID(x2);
idx = x2;