function [params] = prepare_concept_tuning_logfile(params)    

ct = GetSecs;

fprintf(params.fid,['LOGFILE:\b',date,'\b']);
for zt = 1:length(ct);fprintf(params.fid,[num2str(ct(zt)),'\b']);end;
fprintf(params.fid,'\n');

txt = ['Trial\tImage\tCat\tresponseBtn\tOT1\tOT2\tOF1\tRT'];
fprintf(params.fid,txt);
fprintf(params.fid,'\n');
