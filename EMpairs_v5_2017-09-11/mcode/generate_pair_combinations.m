function [c] = generate_pair_combinations(a)
%%
 c = [];
 k = 0;
 for it = 1:size(a,1)
     for jt = 1:size(a,2)
         for kt = 1:size(a,2)
             for lt = 1:size(a,1)
                k = k+1;
                c(k,:) = [a(it,jt) a(lt,kt)];
                
             end;
         end;
     end;     
 end;
 c(find(diff(c,[],2)<1),:) = [];
 
% c = nchoosek(1:length(a(:)),2);