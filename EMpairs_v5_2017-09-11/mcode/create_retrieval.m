function [out] = create_retrieval_log(params)
%% log response to txt file
RT = [params.RT{:}];
x =params.perf{1}.P';x=x(:)';

%block ntrials RT AC TRL_BEG TRL_END OT1 OT2 OT3 
txt = [num2str(params.c),'\t',num2str(length(params.trl_idx)),'\t',num2str(RT),'\t',num2str(x),'\t',num2str(params.trl_idx(1)),'\t',num2str(params.trl_idx(end))];

for jt = 1:size(params.ot,1)
    out = [txt,'\t',params.ot{jt,1},'\t',params.ot{jt,2},'\t',params.ot{jt,3}];
end;