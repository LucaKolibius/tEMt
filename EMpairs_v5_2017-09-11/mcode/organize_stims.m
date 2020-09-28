function [ID] = organize_stims(Imf)
%%
ID = cell(length(Imf),1);

for it = 1:length(Imf)
    ID{it} = Imf(it).name(1:end-5);
end;

ID = reshape(ID,[4 length(ID)/4]);
ID = ID';

x = zeros(size(ID,1),1);
for it = 1:size(ID,1)
    x(it) = length(unique(ID(it,:)));
end;

if any(x>1)
    error('picture names do not match');
end;