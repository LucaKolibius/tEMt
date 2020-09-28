function [params] = prepare_concept_tuning_logfile(params)
if strcmp(params.rep, 'n') % when starting the experiment, prepare logfile header
    ct = GetSecs;
    
    fprintf(params.fid,['LOGFILE:\b',date,'\b']);
    for zt = 1:length(ct)
        fprintf(params.fid,[num2str(ct(zt)),'\b'])
    end
    fprintf(params.fid,'\n');
    
    txt = ['Trial\tImage\tCat\tresponseBtn\tOT1\tOT2\tOF1\tRT'];
    fprintf(params.fid,txt);
    fprintf(params.fid,'\n');
    
elseif strcmp(params.rep, 'y') % resume after a crash
    ct = GetSecs;
    fprintf(params.fid,[num2str(0),'\tResume Experiment\t',date,'\t', num2str(ct),'\n']);
end
end