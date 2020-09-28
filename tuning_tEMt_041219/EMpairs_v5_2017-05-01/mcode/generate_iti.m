function [iti] = generate_iti(iti,ntrl)
%%
if nargin ==0
    iti = [500 3000];
    ntrl = 5000;
end

[iti] = randi([iti(1) iti(2)],ntrl,1);

iti = iti./1000;%convert from ms to s
% [n,x] = hist(iti);
% plot(x,n);
return