function [perf]= compute_accuracy(CM)

if ~any((CM==0)) % if no CM response is 0
    P = 0;
if CM(1) == CM(2) 
    P = 1;
end
    
    %% this is absolutely useless
    C = 1/size(CM,2); % 0.25
    
    P = (P-C)/(1-C);
    P(sign(P)==-1) = 0;
    
    %%
    [H] = sum(P(:))/length(P(:)); % average value of P (0 0.5 1) / also seems useless. in tEMt a hit is H = 1.
    [M] = 1-H;
    %%
    perf.CM = CM;
    perf.P = P;
    perf.H = H;
    perf.M = M;
else % if any CM response is 0
    %%
    perf.CM = zeros(1,2);
    perf.P = zeros(1,1);
    perf.H = zeros(1,1);
    perf.M = zeros(1,1);
end
return
