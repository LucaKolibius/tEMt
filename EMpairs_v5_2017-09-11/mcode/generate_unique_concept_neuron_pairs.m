function [c] = generate_unique_concept_neuron_pairs( concept_neurons )
%%

x1 = [];
x2 = [];
for it = 1:length(concept_neurons)
    
    x1 = [x1 it+zeros(1,length(concept_neurons{it}))];
    x2 = [x2 concept_neurons{it}'];

end;
x1 = x1';
x2 = x2';

x = [x1 x2]
%%
for it = 1:size(x,1)
    
    
    
end;


return;