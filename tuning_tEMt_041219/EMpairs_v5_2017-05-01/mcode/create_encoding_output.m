function [out] = create_encoding_output(params,resp,trl)
%% log response to txt file

%block ntrials STIMID1 STIMID2 STIMID3 OT1 OT2 OT3 RESP RT
txt = [num2str(trl),'\t'];

for it = 1:length(params.enc_id)
    txt = [txt,params.enc_id(it)','\t'];
end;

txt = [txt,params.ot{1},'\t',params.ot{2},'\t',params.ot{3},'\t',num2str(resp.response),'\t',num2str(resp.rt)];

out =[txt{:}];