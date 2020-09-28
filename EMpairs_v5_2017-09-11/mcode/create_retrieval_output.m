function [out] = create_retrieval_output(params,trl)
%% log response to txt file;
RT = params.RT;
x =params.perf{trl}.P';x=x(:)';

%block ntrials TRL_BEG TRL_END RT AC OT1 OT2 OT3 
txt = [num2str(trl),'\t',params.ret_id,'\t'];

for it = 1:length(x)
    txt =[txt,num2str(x(it)),'\t'];
end

for it = 1:length(RT)
    txt = [txt,num2str(RT(it)),'\t'];
end

txt = [txt,params.ot{1},'\t',params.ot{2},'\t',params.ot{3},'\t', params.ot(4),'\t', params.ot(5)];


out = [txt{:}];