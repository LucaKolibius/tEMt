function [c] = generate_concept_neuron_pairs( concept_neurons )
%%
if nargin == 0
    concept_neurons = [2 3 4 5 6];
end;
n = length(concept_neurons);
np = n*(n-1)/2+length(concept_neurons);
k = 0;
c = zeros(np,2);
x1 = 1;
x2 = n;
for it = 1:n
    for jt = x1:x2
        k = k+1;
        c(k,:) = [concept_neurons(it) concept_neurons(jt)];
    end;
    x1 = x1+1;
end;

return;