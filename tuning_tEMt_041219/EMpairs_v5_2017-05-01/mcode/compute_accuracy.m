function [perf]= compute_accuracy(CM)

if ~any((CM==0))
    P = zeros(size(CM,1),2);
    for it = 1:size(CM,1)
        
        P(it,:) = ismember(CM(it,3:4),CM(it,1:2));
        
    end;
    
    C = 1/size(CM,2);
    
    P = (P-C)/(1-C);
    P(sign(P)==-1) = 0;
    
    [H] = sum(P(:))/length(P(:));
    [M] = 1-H;
    %%
    perf.CM = CM;
    perf.P = P;
    perf.H = H;
    perf.M = M;
else
    %%
    perf.CM = zeros(1,4);
    perf.P = zeros(1,2);
    perf.H = zeros(1,1);
    perf.M = zeros(1,1);
end;
return;
